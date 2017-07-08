module VulnerabilitiesHelper

  def link_to_google(vulnerability)
    link_to '', url_to_google(vulnerability), class: 'vuln_link google_link', target: '_blank'
  end

  def link_to_nvd(vulnerability)
    link_to '', url_to_nvd(vulnerability), class: 'vuln_link nvd_link', target: '_blank'
  end

  def link_to_cve_details(vulnerability)
    link_to '', url_to_cve_details(vulnerability), class: 'vuln_link cve_details_link', target: '_blank'
  end

  def url_to_nvd(vulnerability)
    "https://nvd.nist.gov/vuln/detail/#{vulnerability.name}"
  end

  def url_to_cve_details(vulnerability)
    "http://www.cvedetails.com/cve/#{vulnerability.name}/"
  end

  def url_to_google(vulnerability)
    "https://www.google.com/search?q=#{vulnerability.name}"
  end
  
  def link_to_vulnerability(vulnerability)
    link_to vulnerability.name, vulnerability, title: vulnerability.summary
  end

end
