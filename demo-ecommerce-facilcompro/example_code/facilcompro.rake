# frozen_string_literal: true

namespace :facilcompro do
  desc 'Set order_state = cancelled and payment_state = canceled to orders that were created but not paid in 72 hs of its creating'
  task cancel_order_no_paid: :environment do
    puts "Ejecutando facilcompro:cancel_order_no_paid #{Time.zone.now.strftime('%d-%m-%Y %H:%M')}"
    bank_deposit_to_cancel = BankDeposit.select(:id, :order_id).where("bank_deposits.state='pending' and bank_deposits.order_expiration <= ?", Time.zone.now)
    orders = []
    bank_deposit_to_cancel.each do |bd|
      bank_deposit = BankDeposit.find(bd.id)
      bank_deposit.update_attributes!(state: BankDeposit.state.cancelled)
      order = Order.find(bd.order_id)
      order.cancel_payment!
      orders << order.id
    end
    puts "Finalizado #{Time.zone.now.strftime('%d-%m-%Y %H:%M')} con #{bank_deposit_to_cancel.size} ordenes canceladas. #{orders}"
  end

  task reindex_elastic_search: :environment do
    puts "Reindexando modelos en elastic search #{Time.zone.now.strftime('%d-%m-%Y %H:%M')}"
    Rails.application.eager_load!
    Searchkick.models.each do |model|
      puts "Indexando #{model.name}"
      model.reindex
    end
    puts "Reindexado #{Time.zone.now.strftime('%d-%m-%Y %H:%M')}"
  end
end
