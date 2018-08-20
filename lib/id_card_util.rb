# encoding: UTF-8

class IdCardUtil

  @areas = { '11': '北京', '12': '天津', '13': '河北', '14': '山西', '15': '内蒙古',
             '21': '辽宁', '22': '吉林', '23': '黑龙江', '31': '上海', '32': '江苏',
             '33': '浙江', '34': '安徽', '35': '福建', '36': '江西', '37': '山东',
             '41': '河南', '42': '湖北', '43': '湖南', '44': '广东', '45': '广西',
             '46': '海南', '50': '重庆', '51': '四川', '52': '贵州', '53': '云南',
             '54': '西藏', '61': '陕西', '62': '甘肃', '63': '青海', '64': '宁夏',
             '65': '新疆', '71': '台湾', '81': '香港', '82': '澳门', '91': '国外' }

  @powers = %w[7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2]

  @parity_bit = %w[1 0 X 9 8 7 6 5 4 3 2]

  @genders = { boy: '男', girl: '女' }

  def self.check_area(area_code)
    idx = (area_code =~ /^[1-9]\d{5}$/i)
    unless idx.nil?
      acode = @areas[area_code[0..1].to_sym]
      return true unless acode.nil?
    end
    false
  end

  def self.check_birthday(birth_code)
    idx = (birth_code =~ /^[1-9]\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))$/i)
    return false if idx.nil?

    year = (birth_code[0..3]).to_i
    month = (birth_code[4..5]).to_i
    day = (birth_code[6..7]).to_i
    xdate = Date.new(year, month, day)
    tdate = Date.current
    xdate < tdate
  end

  def self.get_parity_bit(card_no)
    power = (0..16).inject(0) { |p, i| p + card_no[i].to_i * @powers[i].to_i }
    @parity_bit[power % 11]
  end

  def self.check_parity_bit(card_no)
    return false if card_no[17].nil?
    get_parity_bit(card_no) == card_no[17].upcase
  end

  # 校验15位的身份证号码
  def self.check_card_no_15(card_no)
    # 15位身份证号码的基本校验
    # idx = (card_no =~ /^[1-9]\d{7}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}$/i)
    valid = /^[1-9]\d{7}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}$/i.match? card_no
    return false unless valid
    # 校验地址码
    return false unless check_area(card_no[0..5])
    # 校验日期码
    check_birthday('19' + card_no[6..11])
  end

  def self.check_card_no_18(card_no)
    # 18位身份证号码的基本格式校验
    # idx = (card_no =~ /^[1-9]\d{5}[1-9]\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}(\d|x|X)$/i)
    valid = /^[1-9]\d{5}[1-9]\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}(\d|x|X)$/i.match? card_no
    return false unless valid
    # 校验地址码
    return false unless check_area(card_no[0..5])
    # 校验日期码
    return false unless check_birthday(card_no[6..13])
    # 验证校检码
    check_parity_bit(card_no)
  end

  def self.check_id_card(card_no)
    # 15位和18位身份证号码的基本校验
    # idx = (card_no =~ /^(\d{15}|(\d{17}(\d|x|X)))$/i.match?card_no
    return false unless /^(\d{15}|(\d{17}(\d|x|X)))$/i.match?card_no
    return check_card_no_15(card_no) if card_no.size == 15
    return check_card_no_18(card_no) if card_no.size == 18
    false
  end

  def self.formate_date(day)
    day[0..3] + '-' + day[4..5] + '-' + day[6..7]
  end

  # 获取信息
  def self.get_id_card_info(card_no)
    gender = nil # 性别
    birthday = nil # 出生日期(yyyy-mm-dd)

    if card_no.length == 15
      birthday = formate_date("19#{card_no[6..11]}")
      gender = (card_no[14].to_i % 2).zero? ? :girl : :boy

    elsif card_no.length == 18
      birthday = formate_date(card_no[6..13])
      gender = (card_no[16].to_i % 2).zero? ? :girl : :boy
    end

    [gender, birthday]
  end

  def self.id_card_to_15(card_no)
    return card_no if card_no.length == 15
    return (card_no[0..5] + card_no[8..17]) if card_no.length == 18
  end

  def self.id_card_to_18(card_no)
    return card_no if card_no.length == 18
    return nil if card_no.length != 15

    id17 = card_no[0..5] + '19' + card_no[6..14]
    bit = get_parity_bit(id17)
    id17 + bit
  end

  def self.random_id_card
    y = rand(70..90).to_s
    m = rand(1..12).to_s.rjust(2, "0")
    d = rand(1..30).to_s.rjust(2, "0")
    s = rand(10..90).to_s
    sex = rand(0..9).to_s
    id = "44011219#{y}#{m}#{d}#{s}#{sex}"
    bit = get_parity_bit(id)
    id + bit
  end
end
