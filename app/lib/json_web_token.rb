class JsonWebToken
  SECRET_KEY = "6553019698684584d97e63d9e4b5123b8a8189eb520a619243663e501793c9dfe7a732f869d2c324f7a94d51173a953c028dbb395f9abe8e341ce02b5228ace2"

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end