-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_camara_compensacao_60_v (nr_seq_compensacao, tp_registro, nr_sequencia, cd_tipo_registro, cd_unimed_destino, cd_unimed_origem, dt_geracao, dt_camara, ie_tipo_camara, nr_versao_transacao, cd_unimed_credora, cd_unimed_devedora, ds_reservado, ie_tipo_fatura, vl_total_fatura, dt_atualizacao_602, qt_total_uni_credora, qt_total_uni_devedora, qt_nr_fatura, vl_total_fatura_609, dt_postagem, nr_protocolo, nr_documento) AS select	nr_sequencia		nr_seq_compensacao,
	1			tp_registro,
	1			nr_sequencia,
	'601'			cd_tipo_registro,
	cd_unimed_destino	cd_unimed_destino,
	cd_unimed_origem	cd_unimed_origem,
	LOCALTIMESTAMP			dt_geracao,
	dt_camara		dt_camara,
	CASE WHEN ie_tipo_camara='IAF' THEN 1 WHEN ie_tipo_camara='F' THEN 2 WHEN ie_tipo_camara='IEF' THEN 3 WHEN ie_tipo_camara='N' THEN 4 END  ie_tipo_camara,
	07			nr_versao_transacao,
	null			cd_unimed_credora,
	null			cd_unimed_devedora,
	null			ds_reservado,
	null			ie_tipo_fatura,
	null			vl_total_fatura,
	null			dt_atualizacao_602,
	null			qt_total_uni_credora,
	null			qt_total_uni_devedora,
	null			qt_nr_fatura,
	null			vl_total_fatura_609,
	null			dt_postagem,
	' '			nr_protocolo,
	' '			nr_documento
FROM	ptu_camara_compensacao

union

select	nr_seq_camara		nr_seq_compensacao,
	2			tp_registro,
	2			nr_sequencia,
	'602'			cd_tipo_registro,
	null			cd_unimed_destino,
	null			cd_unimed_origem,
	null			dt_geracao,
	null			dt_camara,
	null			ie_tipo_camara,
	null			nr_versao_transacao,
	cd_unimed_credora	cd_unimed_credora,
	coalesce(cd_unimed_superior,cd_unimed_devedora) cd_unimed_devedora,
	rpad(' ',11,' ')		ds_reservado,
	ie_tipo_fatura			ie_tipo_fatura,
	vl_total_fatura			vl_total_fatura,
	dt_atualizacao			dt_atualizacao,
	null				qt_total_uni_credora,
	null				qt_total_uni_devedora,
	null				qt_nr_fatura,
	null				vl_total_fatura_609,
	null				dt_postagem,
	' '				nr_protocolo,
	rpad(coalesce(nr_documento,to_char(nr_fatura)),20,' ')	nr_documento
from	ptu_camara_fatura

union

select	nr_seq_camara		nr_seq_compensacao,
	3			tp_registro,
	3			nr_sequencia,
	'609'			cd_tipo_registro,
	null			cd_unimed_destino,
	null			cd_unimed_origem,
	null			dt_geracao,
	null			dt_camara,
	null			ie_tipo_camara,
	null			nr_versao_transacao,
	null			cd_unimed_credora,
	null			cd_unimed_devedora,
	null			ds_reservado,
	null			ie_tipo_fatura,
	null			vl_total_fatura,
	null			dt_atualizacao,
	count(distinct cd_unimed_credora)	qt_total_uni_credora,
	max(( 	select count(distinct x.cd_unimed_devedora)
		from   ptu_camara_fatura x
		where  x.nr_seq_camara = a.nr_seq_camara))qt_total_uni_devedora,
	count(coalesce(nr_fatura,0))		qt_nr_fatura,
	lpad(coalesce(replace(replace(campo_mascara(sum(vl_total_fatura),2),',',''),'.',''),'0'),14,'0') vl_total_fatura_609,
	null			dt_postagem,
	null			nr_protocolo,
	null			nr_documento
from	ptu_camara_fatura a
group by
	nr_seq_camara;

