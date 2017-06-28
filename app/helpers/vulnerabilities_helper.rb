module VulnerabilitiesHelper

  def link_to_nvd(vuln, title='View on NVD')
    link_to title, "https://nvd.nist.gov/vuln/detail/#{vuln.name}"
  end

end
