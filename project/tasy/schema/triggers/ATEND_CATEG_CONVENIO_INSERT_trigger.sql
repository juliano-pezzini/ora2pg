-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_categ_convenio_insert ON atend_categoria_convenio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_categ_convenio_insert() RETURNS trigger AS $BODY$
DECLARE

ie_tipo_convenio_w		smallint := 2;
ie_tipo_convenio_ww		smallint := 2;
ie_tipo_convenio_atend_w	smallint;
ie_situacao_w			varchar(1) := 'A';
dt_cancelamento_w		timestamp := LOCALTIMESTAMP;
cd_estabelecimento_w		integer;
nr_seq_regra_funcao_w		bigint;
nr_seq_regra_funcao_ww		bigint;
ie_situacao_categ_w		varchar(1) := 'A';
ie_exige_orc_atend_w		varchar(1);
dt_entrada_w			timestamp;
cd_medico_resp_w		varchar(10);
ie_tipo_atendimento_w		smallint;
ie_regra_w			varchar(1);
ie_consiste_tipo_conv_w		varchar(1);
ie_atualizar_tipo_conv_atend_w	varchar(1) := 'S';
ie_vigencia_entrada_w		varchar(1);
cd_pessoa_fisica_w		varchar(10);
ie_atualiza_titular_conv_w	varchar(1);
ie_resUnimed_w			varchar(1);
ds_param_integ_hl7_w 		varchar(4000);
cd_convenio_empresa_w 		convenio_empresa.cd_convenio%type;
ie_save_insurance_holder_w	varchar(1);
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S') then

  select	max(cd_estabelecimento)
  into STRICT	cd_estabelecimento_w
  from	atendimento_paciente
  where 	nr_atendimento =  NEW.nr_atendimento;

  select	coalesce(max(ie_consiste_tipo_conv),'N'), /* Rafael em 18/08/06 OS39167*/

    coalesce(max(ie_atualizar_tipo_conv_atend),'S')
  into STRICT	ie_consiste_tipo_conv_w,
    ie_atualizar_tipo_conv_atend_w
  from	parametro_faturamento
  where	cd_estabelecimento = cd_estabelecimento_w;


  BEGIN
  select ie_tipo_convenio,
    ie_situacao,
    dt_cancelamento,
    Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_w, 'IE_EXIGE_ORC_ATEND') ie_exige_orc_atend
  into STRICT	ie_tipo_convenio_w,
    ie_situacao_w,
    dt_cancelamento_w,
    ie_exige_orc_atend_w
  from	convenio
  where	cd_convenio = NEW.cd_convenio;
  exception
    when others then
          ie_tipo_convenio_w := 2;
  end;
  ie_tipo_convenio_ww	:= ie_tipo_convenio_w;
  if (ie_atualizar_tipo_conv_atend_w = 'S') then
    BEGIN
    update	atendimento_paciente
    set	ie_tipo_convenio = ie_tipo_convenio_w
    where	nr_atendimento 	 = NEW.nr_atendimento;
    exception
      when others then
            ie_tipo_convenio_w := 2;
    end;
  end if;

  select	coalesce(max(nr_seq_regra_funcao),0),
    max(dt_entrada),
    max(cd_medico_resp),
    max(ie_tipo_atendimento),
    max(ie_tipo_convenio),
    max(cd_pessoa_fisica)
  into STRICT	nr_seq_regra_funcao_w,
    dt_entrada_w,
    cd_medico_resp_w,
    ie_tipo_atendimento_w,
    ie_tipo_convenio_atend_w,
    cd_pessoa_fisica_w
  from	atendimento_paciente
  where	nr_atendimento	= NEW.nr_atendimento;


  if (ie_consiste_tipo_conv_w = 'S') and (obter_tipo_convenio(NEW.cd_convenio) <> ie_tipo_convenio_ww) then	
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237344);
  end if;

  if (NEW.ie_tipo_guia is not null) then

    CALL gerar_home_care_regra(	NEW.nr_atendimento,
          ie_tipo_atendimento_w,
          NEW.ie_tipo_guia,
          NEW.nm_usuario,
          NEW.cd_convenio,
          NEW.cd_plano_convenio,
          NEW.cd_usuario_convenio);

  end if;

  select	Obter_convenio_regra_atend(cd_medico_resp_w, NEW.cd_convenio,ie_tipo_atendimento_w,cd_estabelecimento_w,'A',NEW.cd_plano_convenio,NEW.cd_categoria)
  into STRICT	ie_regra_w
;

  if (ie_regra_w = 'N') then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237337);
  end if;

  select	coalesce(max(nr_seq_regra_funcao),0)
  into STRICT	nr_seq_regra_funcao_ww
  from	convenio_estabelecimento
  where	cd_estabelecimento	= cd_estabelecimento_w
  and	cd_convenio		= NEW.cd_convenio;
  if (nr_seq_regra_funcao_ww > 0) and (nr_seq_regra_funcao_ww <> nr_seq_regra_funcao_w)then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237338);
  end if;

  select	coalesce(max(ie_vigencia_entrada),'N')
  into STRICT	ie_vigencia_entrada_w
  from	parametro_atendimento
  where	cd_estabelecimento	= cd_estabelecimento_w;

  if (ie_vigencia_entrada_w = 'N') and (dt_entrada_w > NEW.dt_inicio_vigencia) then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237339,'DT_INICIO_VIGENCIA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_inicio_vigencia, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';DT_ENTRADA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
  end if;

  if (NEW.dt_inicio_vigencia > NEW.dt_final_vigencia) then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237343);
  end if;


  if (ie_exige_orc_atend_w = 'S') then
    CALL verifica_orcamento_paciente(NEW.nr_atendimento,NEW.cd_convenio,NEW.cd_categoria);
  end if;

  if (ie_situacao_w <> 'A') then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237345);
  end if;

  if (dt_cancelamento_w is not null) and (dt_entrada_w >= dt_cancelamento_w) then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237346);
  end if;

  select	coalesce(max(ie_situacao ),'X')
  into STRICT	ie_situacao_categ_w
  from	categoria_convenio
  where	cd_convenio = NEW.cd_convenio
  and	cd_categoria = NEW.cd_categoria;

  if (ie_situacao_categ_w <> 'A') then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237347);
  end if;


  if (Obter_Se_Medico_Lib(	cd_estabelecimento_w,
          cd_medico_resp_w,
          NEW.cd_convenio)	= 'N') then
    CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(237348);
  end if;

  CALL gerar_regra_prontuario_conv(NEW.nr_atendimento,NEW.nm_usuario,NEW.cd_convenio,NEW.cd_municipio_convenio);

  ie_save_insurance_holder_w := obter_dados_param_atend(wheb_usuario_pck.get_cd_estabelecimento, 'SI');

  if (coalesce(ie_save_insurance_holder_w,'N') = 'S') and (coalesce(pkg_i18n.get_user_locale, 'pt_BR') <> 'pt_BR') and (cd_pessoa_fisica_w  is not null) and (NEW.cd_convenio is not null) and
    ((coalesce(NEW.cd_convenio, 0) <> coalesce(OLD.cd_convenio, 0)) or (coalesce(NEW.cd_categoria, 0) <> coalesce(OLD.cd_categoria, 0)) or (coalesce(NEW.cd_usuario_convenio, '0') <> coalesce(OLD.cd_usuario_convenio, '0')))
    then
    CALL insere_atualiza_titular_conv(
          NEW.nm_usuario,
          NEW.cd_convenio,
          NEW.cd_categoria,
          cd_pessoa_fisica_w,
          NEW.cd_plano_convenio,
          NEW.dt_inicio_vigencia,
          NEW.dt_final_vigencia,
          NEW.dt_final_vigencia,
          NEW.cd_pessoa_titular,
          NEW.cd_usuario_convenio,
          null,
          'N',
          '2', 
		   0,
          NEW.ekvk_cd_pessoa_fisica,
          NEW.ekvk_nm_pais,
		  NEW.ekvk_nr_cartao,
		  NEW.ekvk_nr_conv,
          NEW.ekvk_sg_conv,
		  NEW.ekvk_nr_seq_tipo_doc,
		  NEW.ekvk_dt_inicio,
		  NEW.ekvk_dt_fim,
      NEW.nr_seq_conv_categ_seg,
		NEW.nr_seq_categoria_iva);
  else
    ie_atualiza_titular_conv_w := obter_param_usuario(916, 842, Obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w, ie_atualiza_titular_conv_w);
    if (coalesce(ie_atualiza_titular_conv_w,'N') <> 'N') then

      if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') not in ('de_DE', 'de_AT')) then
        CALL atualiza_titular_convenio(NEW.nm_usuario,NEW.cd_convenio,NEW.cd_categoria,cd_pessoa_fisica_w,
              NEW.cd_plano_convenio,NEW.dt_inicio_vigencia,NEW.dt_final_vigencia,NEW.dt_validade_carteira,NEW.cd_usuario_convenio, NEW.ie_tipo_conveniado);
      else
        if (existe_atend_controle(NEW.nr_atendimento,0) = 'N') then
          cd_convenio_empresa_w	:= coalesce(obter_convenio_tipo_pj(NEW.nr_atendimento), 0);
          ie_tipo_convenio_w := obter_tipo_convenio(NEW.cd_convenio);

          if (cd_convenio_empresa_w <> NEW.cd_convenio
            and ie_tipo_convenio_w <> 1) then -- Self Payment
            CALL atualiza_titular_convenio(NEW.nm_usuario,NEW.cd_convenio,NEW.cd_categoria,cd_pessoa_fisica_w,
            NEW.cd_plano_convenio,NEW.dt_inicio_vigencia,NEW.dt_final_vigencia,NEW.dt_validade_carteira,NEW.cd_usuario_convenio, NEW.ie_tipo_conveniado);
          end if;
        end if;
      end if;
    end if;
  end if;

  if (NEW.cd_convenio is not null) then
    BEGIN
    --  Gerar RES UNIMED - 000710 - Criacao do RES do beneficiario


    if ( NEW.cd_usuario_convenio is not null) then
      CALL gerar_transacao_res(NEW.nr_atendimento,'00710',obter_usuario_pessoa(cd_medico_resp_w),NEW.cd_convenio,'','');
    end if;

    --  Consultar documentos RES PHILIPS - 01100 - Busca dos documentos clinicos

    CALL gerar_transacao_res(NEW.nr_atendimento,'01100',obter_usuario_pessoa(cd_medico_resp_w),NEW.cd_convenio,'','');

    exception
    when others then
          ie_resUnimed_w := 'N';
    end;

  end if;

  if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'en_AU') then 
  
		select dt_entrada
        into STRICT dt_entrada_w
        from atendimento_paciente
        where nr_atendimento= NEW.nr_atendimento;

        select dt_entrada
        into STRICT dt_entrada_w
        from atendimento_paciente
        where nr_atendimento= NEW.nr_atendimento;

        insert into patient_category_log(
        nr_sequencia,
        nr_seq_interno,
        nr_seq_patient_category_old,
        nr_seq_patient_category_new,
        dt_atualizacao,
        dt_start_category,
        nm_usuario,
        nr_atendimento,
		dt_atualizacao_nrec,
		nm_usuario_nrec
      ) values (
        nextval('patient_category_log_seq'),--patient_category_log_seq.nextval,
        NEW.nr_seq_interno,
        OLD.nr_seq_patient_category,
        NEW.nr_seq_patient_category,
        LOCALTIMESTAMP,
        coalesce(dt_entrada_w,LOCALTIMESTAMP),
        NEW.nm_usuario,
        NEW.nr_atendimento,
		LOCALTIMESTAMP,
		NEW.nm_usuario
      );
    end if;

end if;

  END;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_categ_convenio_insert() FROM PUBLIC;

CREATE TRIGGER atend_categ_convenio_insert
	AFTER INSERT ON atend_categoria_convenio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_categ_convenio_insert();
