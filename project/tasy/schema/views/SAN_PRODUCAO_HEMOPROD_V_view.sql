-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW san_producao_hemoprod_v (nr_seq, ie_tipo_hemo, nr_seq_doacao, nr_seq_derivado, nm_hemocomponente, ie_tipo_derivado, nr_seq_emp_ent, dt_filtro, nm_pessoa_fisica, cd_pessoa_fisica, nr_sangue, ds_tipo_bolsa, ds_tipo_doacao, qt_volume) AS select 	1 nr_seq,
	'P' ie_tipo_hemo, 
	b.nr_sequencia nr_seq_doacao, 
	c.nr_sequencia nr_seq_derivado, 
	c.ds_derivado nm_hemocomponente, 
	c.ie_tipo_derivado, 
	a.nr_seq_emp_ent, 
	b.dt_doacao dt_filtro, 
	substr(obter_iniciais_nome(b.cd_pessoa_fisica,null),1,50) nm_pessoa_fisica, 
	b.cd_pessoa_fisica, 
	b.nr_sangue, 
	substr(obter_valor_dominio(2176,b.ie_tipo_bolsa),1,255) ds_tipo_bolsa, 
	substr(obter_desc_tipo_doacao(b.nr_seq_tipo),1,50) ds_tipo_doacao, 
	(select	max(x.qt_volume) 
	FROM	san_producao x 
	where	x.nr_seq_doacao = b.nr_sequencia) qt_volume 
from	san_doacao b, 
	san_producao a, 
	san_derivado c 
where	a.nr_seq_doacao		= b.nr_sequencia 
and	a.nr_seq_derivado	= c.nr_sequencia 
and	a.dt_fim_producao is not null 
and	c.nr_sequencia		in (1,3,6,7,12,18,2,4) 
and	(((c.nr_sequencia = 12) and not exists (	select	1 
						from	san_producao v 
						where	v.nr_seq_doacao = b.nr_sequencia 
						and	v.nr_seq_derivado = 3)) or (c.nr_sequencia <> 12)) 

union
 
select	2 nr_seq, 
	'P' ie_tipo_hemo, 
	b.nr_sequencia nr_seq_doacao, 
	(substr(san_obter_se_volume_unid(b.nr_sequencia),1,10))::numeric  nr_seq_derivado, 
	substr(obter_desc_san_derivado(san_obter_se_volume_unid(b.nr_sequencia)),1,100) nm_hemocomponente, 
	null ie_tipo_derivado, 
	null nr_seq_emp_ent, 
	b.dt_doacao dt_filtro, 
	substr(obter_iniciais_nome(b.cd_pessoa_fisica,null),1,50) nm_pessoa_fisica, 
	b.cd_pessoa_fisica, 
	b.nr_sangue, 
	substr(obter_valor_dominio(2176,b.ie_tipo_bolsa),1,255) ds_tipo_bolsa, 
	substr(obter_desc_tipo_doacao(b.nr_seq_tipo),1,50) ds_tipo_doacao, 
	(select	max(x.qt_volume) 
	from	san_producao x 
	where	x.nr_seq_doacao = b.nr_sequencia) qt_volume 
from	san_doacao b 
where	1 = 1 
and	b.ie_tipo_bolsa		= 2 
and	exists (select 1 
	    from  san_producao a, 
	    	   san_derivado c 
	where	a.nr_seq_doacao		= b.nr_sequencia 
	and	a.nr_seq_derivado	= c.nr_sequencia 
	and	a.dt_fim_producao is not null 
	and	c.nr_sequencia		in (15,16)) 

union
 
select	3 nr_seq, 
	'P' ie_tipo_hemo, 
	b.nr_sequencia nr_seq_doacao, 
	c.nr_sequencia nr_seq_derivado, 
	c.ds_derivado nm_hemocomponente, 
	c.ie_tipo_derivado, 
	a.nr_seq_emp_ent, 
	a.dt_fim_producao dt_filtro, 
	substr(obter_iniciais_nome(b.cd_pessoa_fisica,null),1,50) nm_pessoa_fisica, 
	b.cd_pessoa_fisica, 
	b.nr_sangue, 
	substr(obter_valor_dominio(2176,b.ie_tipo_bolsa),1,255) ds_tipo_bolsa, 
	substr(obter_desc_tipo_doacao(b.nr_seq_tipo),1,50) ds_tipo_doacao, 
	(select	max(x.qt_volume) 
	from	san_producao x 
	where	x.nr_seq_doacao = b.nr_sequencia) qt_volume 
from	san_doacao b, 
	san_producao a, 
	san_derivado c 
where	a.nr_seq_doacao		= b.nr_sequencia 
and	a.nr_seq_derivado	= c.nr_sequencia 
and	a.dt_fim_producao is not null 
and	c.nr_sequencia		= 5 

union all
 
select	50 nr_seq, 
	'R' ie_tipo_hemo, 
	b.nr_sequencia nr_seq_doacao, 
	c.nr_sequencia nr_seq_derivado, 
	c.ds_derivado nm_hemocomponente, 
	c.ie_tipo_derivado, 
	a.nr_seq_emp_ent, 
	b.dt_emprestimo dt_filtro, 
	null, 
	null, 
	null, 
	null, 
	null, 
	null 
from	san_emprestimo b, 
	san_producao a, 
	san_derivado c 
where	a.nr_seq_emp_ent	= b.nr_sequencia 
and	a.nr_seq_derivado	= c.nr_sequencia 
and	c.nr_sequencia		in (1,3,6,7,12,15,16,18,2,4) 

union all
 
select	51 nr_seq, 
	'R' ie_tipo_hemo, 
	b.nr_sequencia nr_seq_doacao, 
	c.nr_sequencia nr_seq_derivado, 
	c.ds_derivado nm_hemocomponente, 
	c.ie_tipo_derivado, 
	a.nr_seq_emp_ent, 
	b.dt_emprestimo dt_filtro, 
	null, 
	null, 
	null, 
	null, 
	null, 
	null 
from	san_emprestimo b, 
	san_producao a, 
	san_derivado c 
where	a.nr_seq_emp_ent	= b.nr_sequencia 
and	a.nr_seq_derivado	= c.nr_sequencia 
and	c.nr_sequencia		= 5;

