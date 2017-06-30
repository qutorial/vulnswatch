module VulnerabilitiesHelper

  def link_to_nvd(vulnerability, title='View on NVD', other_params = {})
    link_to title, url_to_nvd(vulnerability), other_params
  end

  def url_to_nvd(vulnerability)
    "https://nvd.nist.gov/vuln/detail/#{vulnerability.name}"
  end
  
  def link_to_vulnerability(vulnerability)
    link_to vulnerability.name, vulnerability, title: vulnerability.summary
  end

end
