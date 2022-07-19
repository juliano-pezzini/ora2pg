-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_regra_benef ( nr_seq_contrato_p bigint, nr_seq_segurado_p bigint) AS $body$
DECLARE


ie_exige_vinc_operadora_w	pls_regra_benef_contrato.ie_exige_vinc_operadora%type;
ie_exige_matricula_estip_w	pls_regra_benef_contrato.ie_exige_matricula_estip%type;
ie_exige_matricula_familiar_w	pls_regra_benef_contrato.ie_exige_matricula_familiar%type;
ie_exige_localizacao_empresa_w	pls_regra_benef_contrato.ie_exige_localizacao_empresa%type;
ie_exige_faixa_salarial_w	pls_regra_benef_contrato.ie_exige_faixa_salarial%type;
ie_tipo_vinculo_operadora_w	pls_segurado.ie_tipo_vinculo_operadora%type;
ie_exige_data_recebimento_w     pls_regra_benef_contrato.ie_exige_data_recebimento%type;
cd_matricula_estipulante_w	pls_segurado.cd_matricula_estipulante%type;
cd_matricula_familia_w		pls_segurado.cd_matricula_familia%type;
ie_titularidade_w		varchar(1);
ds_erro_w			varchar(255);
nr_seq_localizacao_benef_w	pls_segurado.nr_seq_localizacao_benef%type;
nr_seq_faixa_salarial_w		pls_segurado.nr_seq_faixa_salarial%type;
dt_recebimento_w		pls_segurado.dt_recebimento%type;
dt_receb_contrato_w		pls_contrato.dt_recebimento%type;

C01 CURSOR FOR
	SELECT	ie_exige_vinc_operadora,
		ie_exige_matricula_estip,
		ie_exige_matricula_familiar,
		ie_exige_localizacao_empresa,
		ie_exige_faixa_salarial,
		coalesce(ie_exige_data_recebimento, 'N')
	from	pls_regra_benef_contrato
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	((ie_titularidade = ie_titularidade_w) or (ie_titularidade = 'A'))
	order by coalesce(ie_titularidade,'A') LIMIT 1;


BEGIN

select	(CASE WHEN (nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') THEN 'D' ELSE 'T' END),
	dt_recebimento
into STRICT	ie_titularidade_w,
	dt_recebimento_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

select 	max(dt_recebimento)
into STRICT 	dt_receb_contrato_w
from 	pls_contrato
where 	nr_sequencia = nr_seq_contrato_p;

open C01;
loop
fetch C01 into
	ie_exige_vinc_operadora_w,
	ie_exige_matricula_estip_w,
	ie_exige_matricula_familiar_w,
	ie_exige_localizacao_empresa_w,
	ie_exige_faixa_salarial_w,
	ie_exige_data_recebimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	ie_tipo_vinculo_operadora,
		cd_matricula_estipulante,
		cd_matricula_familia,
		nr_seq_localizacao_benef,
		nr_seq_faixa_salarial
	into STRICT	ie_tipo_vinculo_operadora_w,
		cd_matricula_estipulante_w,
		cd_matricula_familia_w,
		nr_seq_localizacao_benef_w,
		nr_seq_faixa_salarial_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	if	((ie_exige_vinc_operadora_w = 'S') and (coalesce(ie_tipo_vinculo_operadora_w::text, '') = '')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(230449,null);
	end if;
	
	if	((ie_exige_matricula_estip_w = 'S') and (coalesce(cd_matricula_estipulante_w::text, '') = '')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(230450,null);
	end if;
	
	if	((ie_exige_matricula_familiar_w = 'S') and (coalesce(cd_matricula_familia_w::text, '') = '')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(230451,null);
	end if;
	
	if	((ie_exige_localizacao_empresa_w = 'S') and (coalesce(nr_seq_localizacao_benef_w::text, '') = '')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(241432,null);
	end if;
	
	if	((ie_exige_faixa_salarial_w = 'S') and (coalesce(nr_seq_faixa_salarial_w::text, '') = '')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(301239,null);
	end if;
	
	if (ie_exige_data_recebimento_w = 'S') then
		if (coalesce(dt_receb_contrato_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1075744,null);
		elsif (coalesce(dt_recebimento_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1076716, 'DS_SEGURADO=' || nr_seq_segurado_p || ' - ' || pls_obter_dados_segurado(nr_seq_segurado_p, 'N'));
		end if;
	end if;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_regra_benef ( nr_seq_contrato_p bigint, nr_seq_segurado_p bigint) FROM PUBLIC;

