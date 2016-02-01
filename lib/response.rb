class Response
  attr_accessor :status, :body, :headers

  def initialize(status=200)
    @status = status
    @body = ''
    @headers = {}
  end

  def response
    if @body.is_a?(Hash) || @body.is_a?(Array)
      @headers['Content-Type'] = 'application/json'
      @body = JSON.generate(@body)
    end
    [@status, @headers, [@body]]
  end
end