class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_save { self.first_name = first_name.titleize }
  before_save { self.last_name = last_name.upcase }
  phony_normalize :phone, :default_country_code => 'FR'
  
  has_many :skills, through: :proficiencies
  has_many :proficiencies, dependent: :destroy

  has_many :languages, through: :speaks
  has_many :speaks, dependent: :destroy
  accepts_nested_attributes_for :speaks, :allow_destroy => true

  has_many :events, dependent: :destroy
  has_attached_file :attachment
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, :phony_plausible => true
  validates_attachment_file_name :attachment, :matches => [/pdf\Z/]

  MOBILITY = ["Ile-de-France", "France"]
  EXPERIENCE = ["< 1 an", "1 à 3 ans", "3 à 5 ans", "5 à 8 ans", "> 8 ans"]
  SALARY = ["Moins de 22k", "22-25k", "25-30k", "30-35k", "35-40k", "40-45k", "45-50k", "50-55k", "55-60k", "60-65k", "65-70k", "Plus de 70k"]
  CONTRACT = ["CDD", "CDI", "Freelance", "Stage", "Alternance"]
  INTERVIEW_RESULT = ["Top", "OK", "NOK"]
  INTERVIEW_STATE = ["Contacté", "1er entretien", "2ème entretien", "Présenté aux clients", "Salarié", "Ancien salairé"]


  def self.with_all_skills(q)
    array = q[:skills_id_eq_any] unless q.nil?
    if array.nil?
      select('users.*').joins(:skills)
    else
      select('users.*').joins(:skills).where('skills.id' => array).group("users." + User.column_names.join(', users.')).having("count(*) = #{array.size}")
    end
  end
end
