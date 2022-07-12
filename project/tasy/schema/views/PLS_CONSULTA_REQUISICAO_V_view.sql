-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_consulta_requisicao_v (nr_sequencia, dt_requisicao, nm_segurado, nm_prestador, nm_medico, ds_tipo_guia, nr_seq_req_origem, nr_seq_segurado) AS select	nr_sequencia,
	a.dt_requisicao, 
	substr((select	max(pf.nm_pessoa_fisica) 
	FROM	pessoa_fisica	pf, 
		pls_segurado	s 
	where	pf.cd_pessoa_fisica	= s.cd_pessoa_fisica 
	and	s.nr_sequencia		= a.nr_seq_segurado),1,255) nm_segurado, 
	--substr(pls_obter_dados_segurado(nr_seq_segurado ,'N'),1,255) nm_segurado, 
	substr(pls_obter_dados_prestador(a.nr_seq_prestador,'N'),1,255) nm_prestador, 
	substr((select	pf.nm_pessoa_fisica 
	from 	pessoa_fisica	pf 
	where 	pf.cd_pessoa_fisica	= a.cd_medico_solicitante),1,255) nm_medico, 
	--substr(obter_nome_medico(a.cd_medico_solicitante,'N'),1,255) nm_medico, 
	substr(obter_valor_dominio(1746,a.ie_tipo_guia),1,255) ds_tipo_guia, 
	pls_obter_origem_tratamento(a.nr_sequencia) nr_seq_req_origem, 
	nr_seq_segurado 
from	pls_requisicao a;

