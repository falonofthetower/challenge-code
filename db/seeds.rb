if Rails.env.development?
  payload = JSON.parse(File.read("#{Rails.root}/spec/fixtures/webhooks/single.json")).fetch("body").first


  colors = %w(Blue Red Green Yellow Black)
  types = %w(Dark Light Hazy Fresh)

  colors.each do |color|
    FactoryBot.create(:plan, name: color)
  end

  FactoryBot.create(:match, plan: Plan.find_by(name: 'Blue'), match_string: "Blue~Dark")

  3.times do
    colors.each do |color|
      types.each do |type|
        payload["Plan"]["Name"] = color
        payload["Company"]["Name"] = type
        FactoryBot.create(:event, json_payload: payload)
      end
    end
  end
end
