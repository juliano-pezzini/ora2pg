-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_conv_emp_ajusta_prio ( nr_atendimento_p atend_categoria_convenio.nr_atendimento%type, cd_convenio_p atend_categoria_convenio.cd_convenio%type) AS $body$
DECLARE


nr_prioridade_w			atend_categoria_convenio.nr_prioridade%type;
cd_categoria_w			categoria_convenio.cd_categoria%type;
cd_pessoa_fisica_w    		atendimento_paciente.cd_pessoa_fisica%type;
nr_seq_interno_w		atend_categoria_convenio.nr_seq_interno%type;
nr_seq_tipo_admissao_fat_w	atendimento_paciente.nr_seq_tipo_admissao_fat%type;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
dt_nascimento_w			pessoa_fisica.dt_nascimento%type;

atendCategoriaConvenio CURSOR FOR
	SELECT  ac.nr_seq_interno
	from    atend_categoria_convenio ac
	where   ac.nr_atendimento = nr_atendimento_p
	and     ac.nr_prioridade > 0;

BEGIN

  if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then

	nr_prioridade_w := 1;
	
	select	max(ap.cd_pessoa_fisica),
		max(ap.nr_seq_tipo_admissao_fat),
		max(ap.ie_tipo_atendimento)
	into STRICT 	cd_pessoa_fisica_w,
		nr_seq_tipo_admissao_fat_w,
		ie_tipo_atendimento_w
        from	atendimento_paciente ap
	where 	ap.nr_atendimento = nr_atendimento_p;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 

		select 	max(cc.cd_categoria) 
		into STRICT 	cd_categoria_w   
		from 	categoria_convenio cc
		where   cc.cd_convenio = cd_convenio_p;
	
		if (cd_categoria_w IS NOT NULL AND cd_categoria_w::text <> '') then
		
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

			select	nextval('atend_categoria_convenio_seq')
			into STRICT	nr_seq_interno_w
			;
			
			insert	
			into atend_categoria_convenio(
				nr_seq_interno,
				nr_atendimento,
				cd_convenio,
				cd_categoria,
				dt_inicio_vigencia,
				dt_atualizacao,
				nm_usuario,
				nr_prioridade,
				ie_tipo_conveniado)
			values (
				nr_seq_interno_w,
				nr_atendimento_p,
				cd_convenio_p,
				cd_categoria_w,
				coalesce(dt_nascimento_w, clock_timestamp()),
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				nr_prioridade_w,
				CASE WHEN coalesce(dt_nascimento_w::text, '') = '' THEN  null  ELSE 1 END
			);
			
			for atendCategoriaConvenio_w in atendCategoriaConvenio loop

				update	atend_categoria_convenio
				set	nr_prioridade = nr_prioridade + 1
				where	nr_seq_interno = atendCategoriaConvenio_w.nr_seq_interno
				and	nr_seq_interno <> nr_seq_interno_w;

			end loop;
			commit;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_conv_emp_ajusta_prio ( nr_atendimento_p atend_categoria_convenio.nr_atendimento%type, cd_convenio_p atend_categoria_convenio.cd_convenio%type) FROM PUBLIC;
