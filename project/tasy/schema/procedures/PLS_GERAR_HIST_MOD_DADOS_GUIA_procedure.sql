-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_hist_mod_dados_guia ( nr_seq_guia_p bigint, nm_usuario_p text, cd_doenca_cid_p text) AS $body$
DECLARE


cd_medico_solicitante_w			varchar(10);
nr_seq_prestador_w			bigint;
ie_tipo_guia_w				varchar(2);
ie_regime_internacao_w			varchar(1);
qt_dia_solicitado_w				smallint;
ie_carater_internacao_w			varchar(1);
nr_seq_clinica_w				bigint;
ds_observacao_w				varchar(4000);
nr_seq_uni_exec_w				bigint;
cd_doenca_w				pls_diagnostico.cd_doenca%type;
ie_indicacao_acidente_w			pls_diagnostico.ie_indicacao_acidente%type;
ds_tipo_acomodacao_w                    		pls_tipo_acomodacao.ds_tipo_acomodacao%type;



BEGIN

   if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select	cd_medico_solicitante,
                nr_seq_prestador,
                ie_tipo_guia,
                ie_regime_internacao,
                qt_dia_solicitado,
                ie_carater_internacao,
                nr_seq_clinica,
                nr_seq_uni_exec
	into STRICT	cd_medico_solicitante_w,
                nr_seq_prestador_w,
                ie_tipo_guia_w,
                ie_regime_internacao_w,
                qt_dia_solicitado_w,
                ie_carater_internacao_w,
                nr_seq_clinica_w,
                nr_seq_uni_exec_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;

        	begin
                	select  	cd_doenca,
			ie_indicacao_acidente
	                into STRICT    	cd_doenca_w,
                		ie_indicacao_acidente_w
	                from    pls_diagnostico
                	where   nr_seq_guia             = nr_seq_guia_p
	                and     ie_classificacao        = 'P';
	        exception
	        when others then
                	cd_doenca_w                 := '';
	                ie_indicacao_acidente_w     := '';
	end;

	begin
		select	ds_tipo_acomodacao
		into STRICT	ds_tipo_acomodacao_w
		from	pls_tipo_acomodacao
		where	nr_sequencia = (	SELECT	nr_seq_tipo_acomodacao
					from	pls_guia_plano
					where	nr_sequencia = nr_seq_guia_p);
		exception
		when others then
			ds_tipo_acomodacao_w        := '';
        	end;

	ds_observacao_w :=
	'O usuário '||substr(obter_nome_usuario(nm_usuario_p),1,80)||' alterou os dados da guia em '||
	to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss')||'.'||chr(13)||chr(10)||chr(13)||chr(10)||
	'Médico solicitante: '||cd_medico_solicitante_w||' - '||substr(obter_nome_pf(cd_medico_solicitante_w),1,80)||'.'||chr(13)||chr(10)||
	'Prestador: '||nr_seq_prestador_w||' - '||substr(pls_obter_dados_prestador(nr_seq_prestador_w, 'N'),1,80)||'.'||chr(13)||chr(10)||
	'Tipo guia: '||substr(obter_valor_dominio(1746,ie_tipo_guia_w),1,80)||'.'||chr(13)||chr(10)||
	'Regime internação: '||substr(obter_valor_dominio(1757,ie_regime_internacao_w),1,80)||'.'||chr(13)||chr(10)||
	'Dias solicitados: '||qt_dia_solicitado_w||'.'||chr(13)||chr(10)||
	'Caráter atendimento: '||substr(obter_valor_dominio(1016,ie_carater_internacao_w),1,80)||'.'||chr(13)||chr(10)||
	'Tipo internação: '||substr(pls_obter_desc_tipo_internacao(nr_seq_clinica_w),1,80)||'.'||chr(13)||chr(10)||
	'Operadora executora: '||substr(pls_obter_dados_cooperativa(nr_seq_uni_exec_w,'C'),1,255)||chr(13)||chr(10)||
	'CID: '|| substr(obter_desc_cid_doenca(cd_doenca_w),1,80) ||'.'||chr(13)||chr(10)||
	'Indicação de acidente: ' ||substr(obter_valor_dominio(1759,ie_indicacao_acidente_w),1,80) ||'.'||chr(13)||chr(10)||
	'Tipo Acomodação: ' || ds_tipo_acomodacao_w ||'.'||chr(13)||chr(10)|| '.';


	insert into pls_guia_plano_historico(nr_sequencia,
			nr_seq_guia,
			dt_historico,
			dt_atualizacao,
			nm_usuario,
			ds_observacao,
			ie_origem_historico,
			ie_tipo_historico)
	values (nextval('pls_guia_plano_historico_seq'),
			nr_seq_guia_p,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			ds_observacao_w,
			'A',
			'L');
    end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_hist_mod_dados_guia ( nr_seq_guia_p bigint, nm_usuario_p text, cd_doenca_cid_p text) FROM PUBLIC;
