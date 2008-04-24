require 'mechanize'
require 'logger'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG


username = 'USERNAME'
password = 'PASSWORD'

agent = WWW::Mechanize.new

resp = agent.get("https://www.bell.ca/internetusage")
log.debug("At login page - '#{resp.title}'")

login_form = resp.forms.with.name("loginForm").first
login_form.USER = username
login_form.PASSWORD = password

log.debug("Logging in as #{username}")

resp = agent.submit(login_form)
log.debug("At redirected login page - '#{resp.title}'")

login_form= resp.forms.with.name("Login").first

resp = agent.submit(login_form)
log.debug("At login done page - '#{resp.title}'")

resp.body.each("\n") {|line|
    idx = line.index('setCookie')
    func_idx = line.index('function')
    if idx and not func_idx then
        if line =~ /setCookie\('(.*?)', '(.*?)'/
            log.debug("Setting cookie " + $1)
            cookie = WWW::Mechanize::Cookie.new($1, $2)
            cookie.domain = "secureo.bell.ca"
            class StubUri
                attr_accessor :host
            end
            uri = StubUri.new
            uri.host = "secureo.bell.ca"
            agent.cookie_jar.add(uri, cookie)
        end
    end
}

resp = agent.get("https://secureo.bell.ca/mybell/ociLoadProfileForPage.jsp?destinationPageLabel=resources/login/invisibleLogin/loginCompleted.jsp&destinationContext=mybell&isProtected=true&isPortalPage=false")
log.debug("At loading page - '#{resp.title}'")

resp = agent.get("https://secureo.bell.ca/mybell/ociseclvl3_PrsMyAccts_InternetSvcEq.page")
log.debug("At home page - '#{resp.title}'")

resp = agent.get("https://secureo.bell.ca/mybell/ociseclvl3.portal?_nfpb=true&portlet_10_1_actionOverride=%2Fportlets%2Foci%2FmyLob%2FmyInternet%2FshowBandwithUsage&_windowLabel=portlet_10_1&_pageLabel=ociseclvl3_PrsMyAccts_InternetSvcEq")
log.debug("At bandwith usage page - '#{resp.title}'")

used_gb = nil
total_gb = nil
start_date = nil
end_date = nil

resp.body.each("\n") {|line|
    if line =~ /so.addVariable\('totalVal', (.*?) ?\)/
        if not used_gb
            used_gb = $1
            log.debug("Found used GB: #{used_gb}")
        else
            log.debug("Ignoring additional used GB: #{$1}")
        end
    elsif line =~ /so.addVariable\('thresVal', (.*?) ?\)/
        if not total_gb
            total_gb = $1
            log.debug("Found total GB: #{$total_gb}")
        else
            log.debug("Ignoring additional total GB: #{$1}")
        end
    elsif line =~ /selected>(\d\d\d\d-[A-Z][a-z][a-z]-\d\d?) - (\d\d\d\d-[A-Z][a-z][a-z]-\d\d?)<\/option>/
        log.debug("Found date range #{$1} to #{$2}")
        start_date = $1
        end_date = $2
    end
}

if not used_gb then
    file_name = "debug-output.txt"
    log.warn("Couldn't find usage. Dumping last page to #{file_name}")
    File.open(file_name, "a") { |afile|
        afile.puts(resp.body)
    }
end
