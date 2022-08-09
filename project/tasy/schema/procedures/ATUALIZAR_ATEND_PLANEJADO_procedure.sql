-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_atend_planejado ( nr_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


dt_episodio_w		episodio_paciente.dt_episodio%type;
nr_seq_episodio_w	episodio_paciente.nr_sequencia%type;
ie_departments_w	integer;
cd_pessoa_fisica_w	atendimento_paciente.cd_pessoa_fisica%type;
nr_seq_tipo_admissao_fat_w  atendimento_paciente.nr_seq_tipo_admissao_fat%TYPE;
dt_entrada_w                atendimento_paciente.dt_entrada%TYPE;
nr_seq_tipo_episodio_w      episodio_paciente.nr_seq_tipo_episodio%TYPE;
ie_permite_w                varchar(1);
nr_seq_tipo_epi_w   	integer;
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select  max(te.nr_sequencia)
	into STRICT	nr_seq_tipo_epi_w
	from    tipo_episodio te
	where   te.nr_sequencia = ( SELECT  ep.nr_seq_tipo_episodio
				    from    episodio_paciente ep
				    where   ep.nr_sequencia = (	select	max(ap.nr_seq_episodio)
								from  	atendimento_paciente ap
								where	ap.nr_atendimento = nr_atendimento_p
							      )
				  )
	and     te.ie_tipo = 1
	and     te.ie_situacao = 'A';
	
	if (coalesce(nr_seq_tipo_epi_w, 0) > 0) then
	
		select	max(ap.nr_atendimento)
		into STRICT 	nr_atendimento_w
		from    atendimento_paciente ap
		where   ap.nr_seq_tipo_admissao_fat in (SELECT	taf.nr_sequencia
							from	tipo_admissao_fat taf
							where 	ie_tipo_atendimento = 8
							and 	ie_situacao = 'A'
							)
		and     ap.nr_seq_episodio in (	select  ept.nr_sequencia
						from    episodio_paciente ept
						where   ept.nr_sequencia = (	select  apt.nr_seq_episodio
										from    atendimento_paciente apt
										where   apt.nr_atendimento = nr_atendimento_p
									    )
						)
		and	trunc(ap.dt_entrada) = trunc(clock_timestamp())
		and     ap.nr_atendimento <> nr_atendimento_p;

	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

		SELECT  atepac.nr_seq_tipo_admissao_fat,
			atepac.dt_entrada,
			epipac.nr_seq_tipo_episodio
		INTO STRICT    nr_seq_tipo_admissao_fat_w,
			dt_entrada_w,
			nr_seq_tipo_episodio_w
		FROM    atendimento_paciente atepac,
			episodio_paciente epipac
		WHERE   atepac.nr_seq_episodio = epipac.nr_sequencia
		AND     atepac.nr_atendimento = nr_atendimento_w;

		ie_permite_w := obter_se_permite_internar(nr_seq_tipo_episodio_w, nr_seq_tipo_admissao_fat_w, clock_timestamp(), dt_entrada_w);
	else
		ie_permite_w := 'S';
	end if;
    
    end if;

    IF (ie_permite_w = 'N') AND (coalesce(pkg_i18n.get_user_locale, 'pt_BR') in ('de_DE', 'de_AT')) THEN
        ds_erro_p := obter_desc_expressao(959012);
    ELSE
        update	atendimento_paciente
        set	dt_chegada_paciente = clock_timestamp(),
            dt_entrada = clock_timestamp(),
            dt_atualizacao = clock_timestamp(),
            nm_usuario	= nm_usuario_p
        where	nr_atendimento	= nr_atendimento_p;

        select	count(*)
        into STRICT	ie_departments_w
        from	atend_paciente_unidade
        where 	nr_atendimento	= nr_atendimento_p
        and 	coalesce(dt_saida_unidade::text, '') = '';

        if (coalesce(ie_departments_w,0) > 0)then
            update	atend_paciente_unidade
            set	dt_entrada_unidade = clock_timestamp()
            where 	nr_atendimento	= nr_atendimento_p
            and 	coalesce(dt_saida_unidade::text, '') = '';
        end if;

        select 	max(a.dt_episodio),
            max(a.nr_sequencia)
        into STRICT	dt_episodio_w,
            nr_seq_episodio_w
        from	episodio_paciente a,
            atendimento_paciente b
        where	b.nr_seq_episodio = a.nr_sequencia
        and	b.nr_atendimento = nr_atendimento_p;

        if ( dt_episodio_w > clock_timestamp() ) then
    
            update   episodio_paciente
            set	 dt_episodio = clock_timestamp(),
                 nm_usuario = nm_usuario_p,
                 dt_atualizacao = clock_timestamp()
            where	 nr_sequencia = nr_seq_episodio_w;

        end if;

        update	atend_categoria_convenio
        set	dt_inicio_vigencia = clock_timestamp()
        where	nr_atendimento = nr_atendimento_p
        and 	dt_inicio_vigencia > clock_timestamp();

        commit;
    END IF;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_atend_planejado ( nr_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
