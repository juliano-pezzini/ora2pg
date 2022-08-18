update dic_objeto set ds_sql = 'select r.PRIVACY_READ_STATUS from PRIVACY_NOTICE_USER_READ r, PRIVACY_NOTICE_CUSTOMER c 
where r.LOGGED_IN_USER=:NM_USUARIO and sysdate() between c.DT_INITIAL_VIGENCIA 
and c.DT_FINAL_VIGENCIA and c.IE_OBRIGA_ACEITE = ''S''
and c.IE_SITUACAO = ''A'' and c.IE_NOTIFICATION = ''S'''
where nr_sequencia = 1138957
  and ds_sql = 'select r.PRIVACY_READ_STATUS from PRIVACY_NOTICE_USER_READ r, PRIVACY_NOTICE_CUSTOMER c 
where r.LOGGED_IN_USER=:NM_USUARIO and sysdate between c.DT_INITIAL_VIGENCIA 
and c.DT_FINAL_VIGENCIA and c.IE_OBRIGA_ACEITE = ''S''
and c.IE_SITUACAO = ''A'' and c.IE_NOTIFICATION = ''S''';


