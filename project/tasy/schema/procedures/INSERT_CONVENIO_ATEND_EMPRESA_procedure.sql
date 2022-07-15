-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_convenio_atend_empresa ( nr_atendimento_p bigint, cd_convenio_p bigint) AS $body$
DECLARE


cd_categoria_w			atend_categoria_convenio.cd_categoria%TYPE;
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%TYPE;
ds_pais_usuario_w		varchar(15);
nr_prioridade_w			atend_categoria_convenio.nr_prioridade%type;
nr_seq_tipo_admissao_fat_w	atendimento_paciente.nr_seq_tipo_admissao_fat%type;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
dt_nascimento_w			pessoa_fisica.dt_nascimento%type;


BEGIN

ds_pais_usuario_w := obter_sigla_pais_locale(WHEB_USUARIO_PCK.get_nm_usuario);

  IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') THEN

	SELECT	max(ap.cd_pessoa_fisica),
	 	max(ap.nr_seq_tipo_admissao_fat),
		max(ap.ie_tipo_atendimento)
	INTO STRICT 	cd_pessoa_fisica_w,
		nr_seq_tipo_admissao_fat_w,
		ie_tipo_atendimento_w
	FROM	atendimento_paciente ap
	WHERE 	ap.nr_atendimento = nr_atendimento_p;

	IF (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') THEN 


	SELECT	MAX(CC.CD_CATEGORIA) 
        INTO STRICT 	CD_CATEGORIA_W
	FROM 	CATEGORIA_CONVENIO CC
	WHERE CC.CD_CONVENIO = CD_CONVENIO_P;

	if (ds_pais_usuario_w in ('de_DE', 'de_AT')) then

		select	max(OBTER_PRIOR_PADRAO_CONV_ATEND(nr_atendimento_p, cd_convenio_p))
		into STRICT	nr_prioridade_w
		;
	
	end if;
      
      IF (CD_CATEGORIA_W IS NOT NULL AND CD_CATEGORIA_W::text <> '') THEN
      
	select	max(pf.dt_nascimento)
	into STRICT	dt_nascimento_w
	from    pessoa_fisica pf
	where   pf.cd_pessoa_fisica = cd_pessoa_fisica_w
	and exists ( SELECT	1
		    from	tipo_admissao_fat	taf
		    where 	taf.ie_tipo_atendimento = ie_tipo_atendimento_w
		    and		taf.nr_sequencia = nr_seq_tipo_admissao_fat_w
		    and		taf.ie_tipo_bg = 'S'
		    and		taf.ie_situacao = 'A'
		    and		coalesce(pkg_i18n.get_user_locale, 'pt_BR') in ('de_DE', 'de_AT'));

        INSERT INTO ATEND_CATEGORIA_CONVENIO(NR_SEQ_INTERNO,
           NR_ATENDIMENTO,
           CD_CONVENIO,
           CD_CATEGORIA,
           DT_INICIO_VIGENCIA,
           DT_ATUALIZACAO,
           NM_USUARIO,
           nr_prioridade,
	   ie_tipo_conveniado)
        VALUES (nextval('atend_categoria_convenio_seq'),
           NR_ATENDIMENTO_P,
           CD_CONVENIO_P,
           CD_CATEGORIA_W,
           coalesce(dt_nascimento_w, clock_timestamp()),
           clock_timestamp(),
           WHEB_USUARIO_PCK.get_nm_usuario,
           nr_prioridade_w,
	   CASE WHEN coalesce(dt_nascimento_w::text, '') = '' THEN  null  ELSE 1 END
          );

        COMMIT;

      END IF;

    END IF;

  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_convenio_atend_empresa ( nr_atendimento_p bigint, cd_convenio_p bigint) FROM PUBLIC;

