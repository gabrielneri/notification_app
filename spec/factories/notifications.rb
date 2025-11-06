FactoryBot.define do
  factory :notification do
    channel   { :email }
    recipient { 'user@example.com' }
    subject   { 'Hello' }
    body      { 'Test message' }
    status    { :pending }
  end
end
