-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_exportacao_esus ( nr_seq_lote_p esus_lote_envio.nr_sequencia%type, ie_tipo_lote_esus_p esus_lote_envio.ie_tipo_lote_esus%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_integracao_p text default 'N') AS $body$
DECLARE


cd_cgc_w			estabelecimento.cd_cgc%type;
cd_cnes_estab_w			estabelecimento.cd_cns%type;
cd_municipio_ibge_w		w_esus_header_footer.cd_municipio_ibge%type;
cd_cpf_cnpj_remet_w		w_esus_header_footer.cd_cpf_cnpj_remet%type;
cd_cpf_cnpj_origin_w		w_esus_header_footer.cd_cpf_cnpj_origin%type;
nm_razao_social_reme_w		w_esus_header_footer.nm_razao_social_reme%type;
nm_razao_social_orig_w		w_esus_header_footer.nm_razao_social_orig%type;
cd_contra_chave_rem_w		w_esus_header_footer.cd_contra_chave_rem%type;
cd_uuid_instal_rem_w		w_esus_header_footer.cd_uuid_instal_rem%type;
cd_contra_chave_ori_w		w_esus_header_footer.cd_contra_chave_ori%type;
cd_uuid_instal_orig_w		w_esus_header_footer.cd_uuid_instal_orig%type;
cd_tipo_dado_serializ_w		w_esus_header_footer.cd_tipo_dado_serializ%type;
ds_retorno_integracao_w   varchar(4000);



BEGIN
	delete from w_esus_header_footer where nr_seq_lote_envio = nr_seq_lote_p;

	begin
		select	coalesce(cd_cgc,'0'),
			cd_cns
		into STRICT	cd_cgc_w,
			cd_cnes_estab_w
		from	estabelecimento
		where	cd_estabelecimento = cd_estabelecimento_p  LIMIT 1;

	exception
	when others then
		cd_cgc_w := '0';
		cd_cnes_estab_w := null;
	end;

	if (cd_cgc_w <> '0') then
		begin
		cd_cnes_estab_w		:= coalesce(coalesce(cd_cnes_estab_w,substr(obter_dados_pf_pj('',cd_cgc_w,'CNES'),1,7)),'0');
		cd_municipio_ibge_w	:= substr(obter_dados_pf_pj('',cd_cgc_w,'CDMDV'),1,7);
		cd_cpf_cnpj_remet_w	:= cd_cgc_w;
		cd_cpf_cnpj_origin_w	:= cd_cgc_w;
		nm_razao_social_reme_w	:= upper(substr(elimina_acentos(obter_dados_pf_pj('',cd_cgc_w,'N'),'S'),1,70));
		nm_razao_social_orig_w	:= upper(substr(elimina_acentos(obter_dados_pf_pj('',cd_cgc_w,'N'),'S'),1,70));
		end;
	end if;
	if (cd_cnes_estab_w > 0) then
		begin

		cd_contra_chave_rem_w	:= substr(sus_gerar_uuid_esus(cd_cnes_estab_w,'C'),1,50);
		cd_uuid_instal_rem_w	:= substr(sus_gerar_uuid_esus(cd_cnes_estab_w,'U'),1,50);
		cd_contra_chave_ori_w	:= cd_contra_chave_rem_w;
		cd_uuid_instal_orig_w	:= cd_uuid_instal_rem_w;

		end;
	end if;
/*
2 Ficha de Cadastro Individual
3 Ficha de Cadastro Domiciliar e Territorial
4 Ficha de Atendimento Individual
5 Ficha de Atendimento Odontologico
6 Ficha de Atividade Coletiva
7 Ficha de Procedimentos
8 Ficha de Visita Domiciliar e Territorial
10 Ficha de Atendimento Domiciliar
11 Ficha de Avaliacao de Elegibilidade
12 Marcadores de Consumo Alimentar
13 Ficha complementar - Sindrome neurologica por Zika/Microcefalia
14	Ficha de Vacinacao
*/
	Case ie_tipo_lote_esus_p
		when 1 then
			cd_tipo_dado_serializ_w := 2;
		when 2 then
			cd_tipo_dado_serializ_w := 3;
		when 3 then
			cd_tipo_dado_serializ_w := 4;
		when 4 then
			cd_tipo_dado_serializ_w := 6;
		when 5 then
			cd_tipo_dado_serializ_w := 7;
		when 6 then
			cd_tipo_dado_serializ_w := 8;
		when 7 then
			cd_tipo_dado_serializ_w := 11;
		when 8 then
			cd_tipo_dado_serializ_w := 10;
		when 9 then
			cd_tipo_dado_serializ_w := 5;
		when 10 then
			cd_tipo_dado_serializ_w := 12;
		when 11 then
			cd_tipo_dado_serializ_w := 13;
		when 12 then
			cd_tipo_dado_serializ_w := 14;			
	end case;

	insert into w_esus_header_footer(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_cnes_unidade,
						nr_seq_lote_envio,
						cd_tipo_dado_serializ,
						cd_municipio_ibge,
						cd_cnes_serealizado,
						cd_contra_chave_rem,
						cd_uuid_instal_rem,
						cd_cpf_cnpj_remet,
						nm_razao_social_reme,
						cd_contra_chave_ori,
						cd_uuid_instal_orig,
						cd_cpf_cnpj_origin,
						nm_razao_social_orig)
				values (	nextval('w_esus_header_footer_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						cd_cnes_estab_w,
						nr_seq_lote_p,
						cd_tipo_dado_serializ_w,
						cd_municipio_ibge_w,
						cd_cnes_estab_w,
						cd_contra_chave_rem_w,
						cd_uuid_instal_rem_w,
						cd_cpf_cnpj_remet_w,
						nm_razao_social_reme_w,
						cd_contra_chave_ori_w,
						cd_uuid_instal_orig_w,
						cd_cpf_cnpj_origin_w,
						nm_razao_social_orig_w);
	commit;
	case ie_tipo_lote_esus_p
		when 3 then
			begin
			CALL sus_gerar_w_esus_atend_ind(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 8 then
			begin
			CALL sus_gerar_w_esus_atend_dom(nr_seq_lote_p,ie_tipo_lote_esus_p,nm_usuario_p);
			end;
		when 1 then
			begin
			CALL sus_gerar_w_esus_cad_ind(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 4 then
			begin
			CALL sus_gerar_w_esus_ativ_col(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 5 then
			begin
			CALL sus_gerar_w_esus_procedi(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 6 then
			begin
			CALL sus_gerar_w_esus_vis_dom(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 7 then
			begin
			CALL sus_gerar_w_esus_aval_eleg(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 2 then
			begin
			CALL sus_gerar_w_esus_cad_dom(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 9 then
			begin
			CALL sus_gerar_w_esus_ate_odont(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 10 then
			begin
			CALL sus_gerar_w_esus_con_alim(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 11 then
			begin
			CALL sus_gerar_w_esus_zica_micro(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
		when 12 then
			begin
			CALL sus_gerar_w_esus_vacinacao(nr_seq_lote_p,ie_tipo_lote_esus_p,cd_cnes_estab_w,nm_usuario_p);
			end;
			
	end case;

  if (ie_integracao_p = 'S') then
    begin
    case ie_tipo_lote_esus_p
      when 1 then
        begin
          select BIFROST.SEND_INTEGRATION( 'SUS_CDS.IndividualRegistration',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsIndividualRegistrationRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 2 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.HomeRegister',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsHomeRegisterRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 3 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.IndividualService',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsIndividualServiceRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 4 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.CollectiveActivity',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsCollectiveActivityRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 5 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.Procedures',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsProceduresRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 6 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.HomeVisit',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsHomeVisitRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 7 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.EligibilityAssessment',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsEligibilityAssessmentRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 8 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.HomeCare',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsHomeCareRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 9 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.DentalCare',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsDentalCareRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 10 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.FoodConsumption6Months',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsFoodConsumption6MonthsRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.FoodConsumption6To23Months',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsFoodConsumption6To23MonthsRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.FoodConsumption6To23Months',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsFoodConsumption2YearsRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
      when 11 then
        begin
        select BIFROST.SEND_INTEGRATION( 'SUS_CDS.ComplementaryZikaMicrocephaly',
            'com.philips.tasy.integration.atepac.suscds.request.SusCdsComplementaryZikaMicrocephalyRequest',
            '{"batch" : '||nr_seq_lote_p||'}',
            'integration')
            into STRICT     ds_retorno_integracao_w
;
        end;
    end case;
    end;
  end if;
  exception
   when others then
   begin
      ds_retorno_integracao_w := null;
   end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_exportacao_esus ( nr_seq_lote_p esus_lote_envio.nr_sequencia%type, ie_tipo_lote_esus_p esus_lote_envio.ie_tipo_lote_esus%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_integracao_p text default 'N') FROM PUBLIC;
