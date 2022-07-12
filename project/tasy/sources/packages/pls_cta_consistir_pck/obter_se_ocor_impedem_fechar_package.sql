-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Obt_m se existem ocorr_ncias que impedem fechamento da conta



CREATE OR REPLACE FUNCTION pls_cta_consistir_pck.obter_se_ocor_impedem_fechar ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_status_conta_p pls_conta.ie_status%type, ie_atende_glosado_p pls_analise_conta.ie_atende_glosado%type) RETURNS varchar AS $body$
DECLARE

ie_ocorrencias_w	varchar(1);								


BEGIN

if (ie_status_conta_p	= 'A') then

	if (ie_atende_glosado_p = 'S') then
		ie_ocorrencias_w := 'N';
	else
		select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_ocorrencias_w
		from	pls_analise_conta_item
		where	ie_status		= 'P'
		and	ie_fechar_conta		= 'N'
		and	ie_tipo			= 'O'
		and	nr_seq_conta		= nr_seq_conta_p;
	end if;
else
	--Obt_m exist_ncia de  ocorr_ncias que n_o permitem fechar a conta.*/	

	select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_ocorrencias_w
	from	pls_ocorrencia_benef	a
	where	a.nr_seq_conta		= nr_seq_conta_p
	and	a.ie_fechar_conta	= 'N'
	and	a.ie_situacao = 'A'
	--Se o item j_ foi glosado com outra glosa, pode deixar fechar */

	and	not exists (SELECT	1
				from	pls_conta_proc_v x
				where	x.nr_sequencia = a.nr_seq_conta_proc
				and	x.ie_glosa = 'S'
				
union all

				SELECT	1
				from	pls_conta_mat_v x
				where	x.nr_sequencia = a.nr_seq_conta_mat
				and	x.ie_glosa = 'S');
end if;

return ie_ocorrencias_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_cta_consistir_pck.obter_se_ocor_impedem_fechar ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_status_conta_p pls_conta.ie_status%type, ie_atende_glosado_p pls_analise_conta.ie_atende_glosado%type) FROM PUBLIC;