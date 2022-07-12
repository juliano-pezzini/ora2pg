-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_resp_pedido_status_v40_v (ie_tipo_registro, cd_transacao, nr_sequencia, nr_seq_guia, nr_seq_requisicao, ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, nr_seq_origem, ie_tipo_identificador, dt_validade, ds_observacao, ie_tipo_tabela, cd_servico, ds_servico, ie_autorizado, qt_autorizada, cd_mens_espec_1, cd_mens_espec_2, cd_mens_espec_3, cd_mens_espec_4, cd_mens_espec_5, ds_fim) AS select	1				ie_tipo_registro,
	00361 				cd_transacao,
	nr_sequencia     		nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_executora		cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	nr_seq_execucao  		nr_seq_execucao,
	nr_seq_origem			nr_seq_origem,
	ie_tipo_identificador		ie_tipo_identificador,
	dt_validade            		dt_validade,
	''	          		ds_observacao,
	null	 			ie_tipo_tabela,
	null	  			cd_servico,
	''	 			ds_servico,
	null	  			ie_autorizado,
	null	  			qt_autorizada,
	null				cd_mens_espec_1,
	null				cd_mens_espec_2,
	null				cd_mens_espec_3,
	null				cd_mens_espec_4,
	null				cd_mens_espec_5,
	''				ds_fim
FROM	ptu_resp_pedido_status

union

select	2				ie_tipo_registro,
	null 				cd_transacao,
	nr_sequencia     		nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	''				ie_tipo_cliente,
	null				cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	null     			nr_seq_execucao,
	nr_seq_origem			nr_seq_origem,
	null				ie_tipo_identificador,
	null            		dt_validade,
	Elimina_Acentuacao(ds_observacao) ds_observacao,
	null	 			ie_tipo_tabela,
	null	  			cd_servico,
	''	 			ds_servico,
	null	  			ie_autorizado,
	null	  			qt_autorizado,
	null				cd_mens_espec_1,
	null				cd_mens_espec_2,
	null				cd_mens_espec_3,
	null				cd_mens_espec_4,
	null				cd_mens_espec_5,
	''				ds_fim
from	ptu_resp_pedido_status

union

select	3				ie_tipo_registro,
	null 				cd_transacao,
	nr_seq_resp_ped_status 		nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	''				ie_tipo_cliente,
	null				cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	null     			nr_seq_execucao,
	nr_seq_origem			nr_seq_origem,
	null				ie_tipo_identificador,
	null            		dt_validade,
	''		      		ds_observacao,
	ie_tipo_tabela	 		ie_tipo_tabela,
	cd_servico	  		cd_servico,
	Elimina_Acentuacao(ds_servico)	ds_servico,
	ie_autorizado	  		ie_autorizado,
	qt_autorizado	  		qt_autorizada,
	ptu_obter_inconsist_trans_v40(nr_seq_guia,nr_seq_requisicao,b.nr_sequencia,'00361',1,null,null) cd_mens_espec_1,
	ptu_obter_inconsist_trans_v40(nr_seq_guia,nr_seq_requisicao,b.nr_sequencia,'00361',2,null,null) cd_mens_espec_2,
	ptu_obter_inconsist_trans_v40(nr_seq_guia,nr_seq_requisicao,b.nr_sequencia,'00361',3,null,null) cd_mens_espec_3,
	ptu_obter_inconsist_trans_v40(nr_seq_guia,nr_seq_requisicao,b.nr_sequencia,'00361',4,null,null) cd_mens_espec_4,
	ptu_obter_inconsist_trans_v40(nr_seq_guia,nr_seq_requisicao,b.nr_sequencia,'00361',5,null,null) cd_mens_espec_5,
	''				ds_fim
from	ptu_resp_servico_status		b,
	ptu_resp_pedido_status		a
where	b.nr_seq_resp_ped_status	= a.nr_sequencia

union

select	4				ie_tipo_registro,
	null 				cd_transacao,
	nr_sequencia     		nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	''				ie_tipo_cliente,
	null				cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	null     			nr_seq_execucao,
	nr_seq_origem			nr_seq_origem,
	null				ie_tipo_identificador,
	null            		dt_validade,
	''		      		ds_observacao,
	null	 			ie_tipo_tabela,
	null	  			cd_servico,
	''	 			ds_servico,
	null	  			ie_autorizado,
	null	  			qt_autorizado,
	null				cd_mens_espec_1,
	null				cd_mens_espec_2,
	null				cd_mens_espec_3,
	null				cd_mens_espec_4,
	null				cd_mens_espec_5,
	'FIM$'				ds_fim
from	ptu_resp_pedido_status;

