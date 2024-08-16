# [Rails: SidekiqはActive Jobを経由せずに直接使おう（翻訳）](https://techracho.bpsinc.jp/hachi8833/2023_03_06/127675)
# 1. ActiveJobの非利用: Sidekiqがパラメータ、Redis、エラーをどのように管理するのか理解
# 2. ActiveJobの利用: 1 + ActiveJobの理解
#
# ActiveJobの利用を選択しても得られるメリットが薄いため、ActiveJobは利用しない
class ApplicationJob
  include Sidekiq::Worker
end
