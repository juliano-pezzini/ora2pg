-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_dados_analise_auto ( nr_seq_analise_p bigint, cd_medico_solicitante_p INOUT text, nr_seq_prestador_p INOUT bigint, cd_prestador_p INOUT text, ie_tipo_guia_p INOUT text, ie_regime_internacao_p INOUT text, qt_dia_solicitado_p INOUT bigint, ie_carater_internacao_p INOUT text, nr_seq_clinica_p INOUT bigint, cd_unimed_exec_p INOUT text, cd_doenca_cid_p INOUT text, dt_admissao_hosp_p INOUT text, ie_indicacao_acid_p INOUT bigint, nr_seq_tipo_acomodacao_p INOUT bigint) AS $body$
DECLARE

nr_seq_guia_w		bigint;
					

BEGIN
select	max(nr_seq_guia)
into STRICT	nr_seq_guia_w
from	pls_auditoria
where	nr_sequencia = nr_seq_analise_p;

if (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
	select	cd_medico_solicitante,
		nr_seq_prestador,
		ie_tipo_guia,
		ie_regime_internacao,
		qt_dia_solicitado,
		ie_carater_internacao,
		nr_seq_clinica,
		substr(pls_obter_cod_prestador(nr_seq_prestador,null),1,255),
		substr(pls_obter_dados_cooperativa(nr_seq_uni_exec,'C'),1,255),
		dt_admissao_hosp,
		nr_seq_tipo_acomodacao
	into STRICT	cd_medico_solicitante_p,
		nr_seq_prestador_p,
		ie_tipo_guia_p,
		ie_regime_internacao_p,
		qt_dia_solicitado_p,
		ie_carater_internacao_p,
		nr_seq_clinica_p,
		cd_prestador_p,
		cd_unimed_exec_p,
		dt_admissao_hosp_p,
		nr_seq_tipo_acomodacao_p
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_w;

        begin
                select  cd_doenca,
                        ie_indicacao_acidente
                into STRICT    cd_doenca_cid_p,
                        ie_indicacao_acid_p
                from    pls_diagnostico
                where   nr_seq_guia      = nr_seq_guia_w
                and     ie_classificacao = 'P';

        exception
        when others then
                cd_doenca_cid_p         := '';
                ie_indicacao_acid_p     := '';
        end;




        
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_dados_analise_auto ( nr_seq_analise_p bigint, cd_medico_solicitante_p INOUT text, nr_seq_prestador_p INOUT bigint, cd_prestador_p INOUT text, ie_tipo_guia_p INOUT text, ie_regime_internacao_p INOUT text, qt_dia_solicitado_p INOUT bigint, ie_carater_internacao_p INOUT text, nr_seq_clinica_p INOUT bigint, cd_unimed_exec_p INOUT text, cd_doenca_cid_p INOUT text, dt_admissao_hosp_p INOUT text, ie_indicacao_acid_p INOUT bigint, nr_seq_tipo_acomodacao_p INOUT bigint) FROM PUBLIC;

