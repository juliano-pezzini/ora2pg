-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registra_inicio_adm_qt ( nr_seq_atendimento_p bigint, nr_seq_p bigint, ie_tipo_seq_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_material_w		bigint;
ds_material_w			varchar(255);
ie_mat_concelado_w		varchar(1);
ie_param47_w                   varchar(1);
ie_param31_w                   varchar(1);
ie_administracao_w              varchar(10);
					
C01 CURSOR FOR
	SELECT	nr_seq_material
	from 	paciente_atend_medic
	where	nr_seq_atendimento	=	nr_seq_atendimento_p
	and	nr_agrupamento		=	nr_seq_p
	and	coalesce(ie_cancelada,'N')	=	'N';
	
C02 CURSOR FOR
	SELECT	nr_seq_material
	from 	paciente_atend_medic
	where	nr_seq_atendimento	=	nr_seq_atendimento_p
	and	nr_seq_solucao		=	nr_seq_p
	and	coalesce(ie_cancelada,'N')	=	'N';
	

BEGIN

ie_param47_w := Obter_Param_Usuario(3130, 47, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param47_w);
ie_param31_w := Obter_Param_Usuario(3130, 31, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param31_w);

if (ie_tipo_seq_p = 'A') then  -- Agrupador
	open C01;
	loop
	fetch C01 into	
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') and (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
			
			insert into paciente_atend_medic_adm(	
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_atendimento,
							nr_seq_material,
							dt_administracao,
							cd_profissional,
							ds_observacao,
							ie_status_adm,
							dt_fim_administracao)
						values (
							nextval('paciente_atend_medic_adm_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_atendimento_p,
							nr_seq_material_w,
							clock_timestamp(),
							obter_pessoa_fisica_usuario(nm_usuario_p,'C'),
							null,
							1,
							null);

            if (ie_param47_w = 'S') and (ie_param31_w = 'S') then
                ie_administracao_w := 'A';
            else
                ie_administracao_w := 'AP';
            end if;
							
			update		paciente_atend_medic
			set		ie_administracao	=	ie_administracao_w,
					nm_usuario		=	nm_usuario_p,
					dt_atualizacao		=	clock_timestamp()
			where		nr_seq_atendimento	=	nr_seq_atendimento_p
			and		nr_seq_material		=	nr_seq_material_w
			and		coalesce(ie_cancelada,'N')	=	'N';

            if (ie_param47_w = 'S') and (ie_param31_w = 'S') then
                CALL registrar_fim_adm_att(nr_seq_atendimento_p, nr_seq_p, nm_usuario_p);
            end if;
			
		end if;
		end;
	end loop;
	close C01;

elsif (ie_tipo_seq_p = 'S') then  -- Solucao
	open C02;
	loop
	fetch C02 into	
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		
		if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') and (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
			
			insert into paciente_atend_medic_adm(	
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_atendimento,
							nr_seq_material,
							dt_administracao,
							cd_profissional,
							ds_observacao,
							ie_status_adm,
							dt_fim_administracao)
						values (
							nextval('paciente_atend_medic_adm_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_atendimento_p,
							nr_seq_material_w,
							clock_timestamp(),
							obter_pessoa_fisica_usuario(nm_usuario_p,'C'),
							null,
							1,
							null);

            if (ie_param47_w = 'S') and (ie_param31_w = 'S') then
                ie_administracao_w := 'A';
            else
                ie_administracao_w := 'AP';
            end if;
			
			update		paciente_atend_medic
			set		ie_administracao	=	ie_administracao_w,
					nm_usuario		=	nm_usuario_p,
					dt_atualizacao		=	clock_timestamp()
			where		nr_seq_atendimento	=	nr_seq_atendimento_p
			and		nr_seq_material		=	nr_seq_material_w
			and		coalesce(ie_cancelada,'N')	=	'N';

            if (ie_param47_w = 'S') and (ie_param31_w = 'S') then
                CALL registrar_fim_adm_att(nr_seq_atendimento_p, nr_seq_p, nm_usuario_p);
            end if;
			
		end if;
		end;
	end loop;
	close C02;

elsif (ie_tipo_seq_p = 'M') then  -- Material
	if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') and (nr_seq_p IS NOT NULL AND nr_seq_p::text <> '') then
		
		select 	coalesce(max('S'),'N')
		into STRICT	ie_mat_concelado_w
		from	paciente_atend_medic
		where	nr_seq_atendimento	=	nr_seq_atendimento_p
		and	nr_seq_material		=	nr_seq_p
		and 	coalesce(ie_cancelada,'N')	=	'S';
		
		if (ie_mat_concelado_w = 'S') then
			select 	substr(obter_desc_material(cd_material),1,200)
			into STRICT	ds_material_w
			from	paciente_atend_medic
			where	nr_seq_atendimento	=	nr_seq_atendimento_p
			and	nr_seq_material		=	nr_seq_p;
			
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(351451, 'DS_MATERIAL_W='||ds_material_w);
		end if;
		
		insert into paciente_atend_medic_adm(	
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_atendimento,
						nr_seq_material,
						dt_administracao,
						cd_profissional,
						ds_observacao,
						ie_status_adm,
						dt_fim_administracao)
					values (
						nextval('paciente_atend_medic_adm_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_atendimento_p,
						nr_seq_p,
						clock_timestamp(),
						obter_pessoa_fisica_usuario(nm_usuario_p,'C'),
						null,
						1,
						null);

        if (ie_param47_w = 'S') and (ie_param31_w = 'S') then
            ie_administracao_w := 'A';
        else
            ie_administracao_w := 'AP';
        end if;
		
		update		paciente_atend_medic
		set		ie_administracao	=	ie_administracao_w,
				nm_usuario		=	nm_usuario_p,
				dt_atualizacao		=	clock_timestamp()
		where		nr_seq_atendimento	=	nr_seq_atendimento_p
		and		nr_seq_material		=	nr_seq_p;

        if (ie_param47_w = 'S') and (ie_param31_w = 'S') then
            CALL registrar_fim_adm_att(nr_seq_atendimento_p, nr_seq_p, nm_usuario_p);
        end if;
		
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registra_inicio_adm_qt ( nr_seq_atendimento_p bigint, nr_seq_p bigint, ie_tipo_seq_p text, nm_usuario_p text) FROM PUBLIC;

