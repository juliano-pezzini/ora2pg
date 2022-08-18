SET client_encoding TO 'UTF8';

update dic_objeto set ds_sql = 'select * from PRIVACY_NOTICE_CUSTOMER where IE_OBRIGA_ACEITE = ''S'' and IE_SITUACAO = ''A''
and sysdate() between DT_INITIAL_VIGENCIA and DT_FINAL_VIGENCIA and IE_NOTIFICATION = ''S'''
where nr_sequencia = 1142529
  and ds_sql = 'select * from PRIVACY_NOTICE_CUSTOMER where IE_OBRIGA_ACEITE = ''S'' and IE_SITUACAO = ''A''
and sysdate between DT_INITIAL_VIGENCIA and DT_FINAL_VIGENCIA and IE_NOTIFICATION = ''S''';
