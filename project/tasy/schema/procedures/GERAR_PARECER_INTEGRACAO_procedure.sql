-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_parecer_integracao ( nr_cpf_p text default null, cd_nacionalidade_p text default null, dt_nascimento_p text default null, ie_sexo_p text default null, nm_pessoa_fisica_p text default null, nm_mae_p text default null, cd_cnpj_p text default null, ie_tipo_p text default null, ie_status_p text default null, nr_seq_regulacao_p text default null, ds_parecer_p text default null, qt_solicitado_p text default null, ie_origem_proced_p text default null, cd_medico_dest_p text default null, cd_especialidade_p text default null, ds_cod_prof_person_med_p text default null, --medico destino
 nr_seq_cons_person_med_p text default null, --medico destino
 nr_cpf_person_med_p text default null, --medico destino
 nm_pessoa_fisica_med_p text default null,  --medico destino
 cd_pessoa_fisica_med_p text default null, --medico destino
 ds_codigo_prof_prof_p text default null, --profissional solicitante
 nr_seq_cons_prof_p text default null, --profissional solicitante
 nr_cpf_prof_p text default null, --profissional solicitante
 nm_pessoa_fisica_prof_p text default null, --profissional solicitante
 cd_pessoa_fisica_prof_p text default null, --profissional solicitante
 nr_seq_cbo_saude_p text default null, ds_especialidade_p text default null, cd_ptu_p text default null, cd_especialidade_ext_p text default null, cd_ptu_ori_p text default null, nr_seq_paracer_origem_p text default null, nm_usuario_p text default null) AS $body$
DECLARE


			
cd_pessoa_fisica_w		varchar(10);
cd_pessoa_fisica_med_dest_w		varchar(10);
nr_seq_parecer_w			bigint;
cd_especialidade_dest_w		integer;
cd_especialidade_ori_w		integer;
nr_atendimento_w			bigint;

cd_pessoa_fisica_prof_w  varchar(10);

nm_usuario_w		  varchar(15);			


BEGIN

Select  max('T.I.E') -- Integração Bifrost
into STRICT	nm_usuario_w
;


select	max(cd_pessoa_fisica)
into STRICT 	cd_pessoa_fisica_w		
from	pessoa_fisica
where	nr_cpf = nr_cpf_p;

if ( coalesce(cd_pessoa_fisica_w::text, '') = '')then

select	max(cd_pessoa_fisica)
into STRICT 	cd_pessoa_fisica_w		
from	pessoa_fisica
where	dt_nascimento = dt_nascimento_p
and		ie_sexo	= ie_sexo_p
and 	UPPER(nm_pessoa_fisica) = UPPER(nm_pessoa_fisica_p)
and 	UPPER(obter_nome_mae_pf(cd_pessoa_fisica)) like UPPER(nm_mae_p);

	
	if ( coalesce(cd_pessoa_fisica_w::text, '') = '')then

		select	nextval('pessoa_fisica_seq')
		into STRICT	cd_pessoa_fisica_w
		;
		

		insert into pessoa_fisica(
			cd_pessoa_fisica,
			ie_tipo_pessoa,
			nm_pessoa_fisica,
			nr_cpf,
			ie_sexo,
			dt_nascimento,
			dt_atualizacao,
			nm_usuario)
		values (	to_char( cd_pessoa_fisica_w ),
			1,
			nm_pessoa_fisica_p,
			nr_cpf_p,
			ie_sexo_p,
			dt_nascimento_p,
			clock_timestamp(),
			nm_usuario_w);
			
			commit;
	end if;
end if;


--Medico Destino
select	max(cd_pessoa_fisica)
into STRICT 	cd_pessoa_fisica_med_dest_w		
from	pessoa_fisica
where	nr_cpf = nr_cpf_person_med_p;


if ( coalesce(cd_pessoa_fisica_med_dest_w::text, '') = '')then

	select	max(cd_pessoa_fisica)
	into STRICT 	cd_pessoa_fisica_med_dest_w	
	from	pessoa_fisica
	where	ds_codigo_prof = ds_cod_prof_person_med_p
	and		nr_seq_conselho	= nr_seq_cons_person_med_p;
	

end if;

--Medico  Origem
select	max(cd_pessoa_fisica)
into STRICT 	cd_pessoa_fisica_prof_w		
from	pessoa_fisica
where	nr_cpf = nr_cpf_prof_p;


if ( coalesce(cd_pessoa_fisica_prof_w::text, '') = '')then

	select	max(cd_pessoa_fisica)
	into STRICT 	cd_pessoa_fisica_prof_w	
	from	pessoa_fisica
	where	ds_codigo_prof = ds_codigo_prof_prof_p
	and		nr_seq_conselho	= nr_seq_cons_prof_p;
	

end if;

-- Especialidade destino
select	max(cd_especialidade)
into STRICT	cd_especialidade_dest_w
from	especialidade_medica
where	cd_ptu = cd_ptu_p;

-- Especialidade  origem
select	max(cd_especialidade)
into STRICT	cd_especialidade_ori_w 
from	especialidade_medica
where	cd_ptu = cd_ptu_ori_p;

if(( (cd_pessoa_fisica_med_dest_w IS NOT NULL AND cd_pessoa_fisica_med_dest_w::text <> '') or (cd_especialidade_dest_w IS NOT NULL AND cd_especialidade_dest_w::text <> '')) and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') )then

	select	nextval('parecer_medico_req_seq')
	into STRICT	nr_seq_parecer_w
	;
	
	

	insert into parecer_medico_req(
						nr_parecer,
						cd_medico,
						cd_pessoa_fisica,
						cd_especialidade_dest,
						cd_pessoa_parecer,
						ie_integracao,
						ie_situacao,
						nm_usuario_nrec,
						nm_usuario,
						dt_atualizacao_nrec,
						dt_atualizacao,
						nr_seq_regulacao_ori,
						cd_cgc,
						ds_motivo_consulta,
						dt_liberacao,
						cd_especialidade,
						nr_seq_origem
					) values (
						nr_seq_parecer_w,
						coalesce(cd_pessoa_fisica_prof_w, cd_pessoa_fisica_prof_p),
						cd_pessoa_fisica_w,
						cd_especialidade_dest_w,
						cd_pessoa_fisica_med_dest_w,
						'S',
						'A',
						nm_usuario_w,
						nm_usuario_w,
						clock_timestamp(),
						clock_timestamp(),
						nr_seq_regulacao_p,
						cd_cnpj_p,
						ds_parecer_p,
						clock_timestamp(),
						cd_especialidade_ori_w,
						nr_seq_paracer_origem_p
					);

		commit;

		CALL inserir_worklist_integracao(cd_especialidade_dest_w,cd_pessoa_fisica_med_dest_w,cd_pessoa_fisica_w);
		
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_parecer_integracao ( nr_cpf_p text default null, cd_nacionalidade_p text default null, dt_nascimento_p text default null, ie_sexo_p text default null, nm_pessoa_fisica_p text default null, nm_mae_p text default null, cd_cnpj_p text default null, ie_tipo_p text default null, ie_status_p text default null, nr_seq_regulacao_p text default null, ds_parecer_p text default null, qt_solicitado_p text default null, ie_origem_proced_p text default null, cd_medico_dest_p text default null, cd_especialidade_p text default null, ds_cod_prof_person_med_p text default null, nr_seq_cons_person_med_p text default null, nr_cpf_person_med_p text default null, nm_pessoa_fisica_med_p text default null, cd_pessoa_fisica_med_p text default null, ds_codigo_prof_prof_p text default null, nr_seq_cons_prof_p text default null, nr_cpf_prof_p text default null, nm_pessoa_fisica_prof_p text default null, cd_pessoa_fisica_prof_p text default null, nr_seq_cbo_saude_p text default null, ds_especialidade_p text default null, cd_ptu_p text default null, cd_especialidade_ext_p text default null, cd_ptu_ori_p text default null, nr_seq_paracer_origem_p text default null, nm_usuario_p text default null) FROM PUBLIC;

