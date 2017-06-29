module VulnerabilitiesHelper

  def link_to_nvd(vuln, title='View on NVD', other_params = {})
    link_to title, url_to_nvd(vuln), other_params
  end

  def url_to_nvd(vuln)
    "https://nvd.nist.gov/vuln/detail/#{vuln.name}"
  end

end
