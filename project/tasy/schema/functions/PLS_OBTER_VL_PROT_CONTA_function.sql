-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_vl_prot_conta ( ie_tipo_vl_p text, ie_opcao_p text, nr_seq_ref_p bigint) RETURNS bigint AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter valor apresentado e liberado das contas e protocolos
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
IE_OPCAO_P -------IE_OPCAO_P -------IE_OPCAO_P -------IE_OPCAO_P -------IE_OPCAO_P
P - Procolo
C - Conta
IE_OPCAO_P -------IE_OPCAO_P -------IE_OPCAO_P -------IE_OPCAO_P -------IE_OPCAO_P
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
IE_TIPO_VL_P -------IE_TIPO_VL_P -------IE_TIPO_VL_P -------IE_TIPO_VL_P
A - Apresentado
L - Liberado
IE_TIPO_VL_P -------IE_TIPO_VL_P -------IE_TIPO_VL_P -------IE_TIPO_VL_P
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		double precision;
vl_referencia_w		double precision;


BEGIN

if (ie_opcao_p = 'C') then
	if (ie_tipo_vl_p = 'A') then
		select 	vl_cobrado
		into STRICT	vl_referencia_w
		from	pls_conta
		where	nr_sequencia = nr_seq_ref_p;
	elsif (ie_tipo_vl_p = 'L') then
		select 	vl_total
		into STRICT	vl_referencia_w
		from	pls_conta
		where	nr_sequencia = nr_seq_ref_p;
	end if;
elsif (ie_opcao_p = 'P') then
	if (ie_tipo_vl_p = 'A') then
		select  sum(vl_cobrado)
		into STRICT	vl_referencia_w
		from    pls_conta
		where   nr_sequencia in (	SELECT	nr_seq_conta
						from  	PLS_REC_GLOSA_CONTA
						where  	nr_seq_protocolo = nr_seq_ref_p);
	elsif (ie_tipo_vl_p = 'L') then
		select  sum(vl_total)
		into STRICT	vl_referencia_w
		from    pls_conta
		where   nr_sequencia in (	SELECT	nr_seq_conta
						from  	PLS_REC_GLOSA_CONTA
						where  	nr_seq_protocolo = nr_seq_ref_p);
	end if;
end if;

ds_retorno_w := coalesce(vl_referencia_w,0);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_vl_prot_conta ( ie_tipo_vl_p text, ie_opcao_p text, nr_seq_ref_p bigint) FROM PUBLIC;
