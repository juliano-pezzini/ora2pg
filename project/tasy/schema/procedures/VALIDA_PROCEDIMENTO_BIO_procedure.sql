-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_procedimento_bio (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_biometria_p text, nm_usuario_aux_biometria_p text, nr_seq_participante_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
cd_medico_exec_w		varchar(255);
ie_gerar_somente_medico_w	varchar(1);
ie_gerar_somente_auxiliar_w	varchar(1);
ie_validado_w			varchar(1) := 'S';
nr_cirurgia_w			bigint;
ie_funcao_w			varchar(10);
cd_pessoa_fisica_w		varchar(10);
ie_funcao_ww			varchar(10);
cd_pessoa_fisica_ww		varchar(10);

 
c01 CURSOR FOR				  
	SELECT 	cd_pessoa_fisica, 
		ie_funcao 
	from	cirurgia_participante 
	where	nr_seq_interno = nr_seq_participante_p;


BEGIN 
ie_gerar_somente_medico_w := Obter_Param_Usuario(900, 455, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_somente_medico_w);
ie_gerar_somente_auxiliar_w := Obter_Param_Usuario(900, 524, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_somente_auxiliar_w);
 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and 
	((nm_usuario_biometria_p IS NOT NULL AND nm_usuario_biometria_p::text <> '') or (nm_usuario_aux_biometria_p IS NOT NULL AND nm_usuario_aux_biometria_p::text <> '')) then 
	if (nm_usuario_biometria_p IS NOT NULL AND nm_usuario_biometria_p::text <> '') then	 
		select 	max(cd_medico_cirurgiao) 
		into STRICT	cd_medico_exec_w 
		from	cirurgia 
		where	nr_prescricao = nr_prescricao_p;
		 
		if (coalesce(ie_gerar_somente_medico_w,'N') = 'M') and (coalesce(cd_medico_exec_w,0) <> obter_pessoa_fisica_usuario(nm_usuario_biometria_p,'C')) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(204265);
		else 
			update	prescr_procedimento 
			set	dt_biometria = clock_timestamp(), 
				nm_usuario_biometria = nm_usuario_biometria_p, 
				nm_usuario = nm_usuario_p, 
				dt_atualizacao = clock_timestamp() 
			where	nr_sequencia = nr_sequencia_p 
			and 	nr_prescricao = nr_prescricao_p;
		end if;
	else	 
		if (ie_gerar_somente_auxiliar_w = 'P') then 
			ie_validado_w := 'N';
		 
			select	max(nr_cirurgia) 
			into STRICT	nr_cirurgia_w 
			from	cirurgia 
			where	nr_prescricao = nr_prescricao_p;
			 
			open C01;
			loop 
			fetch C01 into	 
				cd_pessoa_fisica_w, 
				ie_funcao_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				if (cd_pessoa_fisica_w = obter_pessoa_fisica_usuario(nm_usuario_aux_biometria_p,'C')) then 
					ie_validado_w 		:= 'S';
					cd_pessoa_fisica_ww	:= cd_pessoa_fisica_w;
					ie_funcao_ww		:= ie_funcao_w;
				end if;	
				end;
			end loop;
			close C01;
		else 
			select 	max(cd_pessoa_fisica), 
				max(ie_funcao) 
			into STRICT	cd_pessoa_fisica_ww, 
				ie_funcao_ww 
			from	cirurgia_participante 
			where	nr_seq_interno = nr_seq_participante_p;
		end if;
		 
		if (ie_validado_w = 'N') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(239257);
		else 
			/* 
			update	prescr_procedimento 
			set	dt_biometria_aux	 = sysdate, 
				nm_usuario_aux_biometria = nm_usuario_aux_biometria_p, 
				nm_usuario 		 = nm_usuario_p, 
				dt_atualizacao 		 = sysdate 
			where	nr_sequencia 		 = nr_sequencia_p 
			and 	nr_prescricao 		 = nr_prescricao_p; 
			*/
 
			insert	into prescr_proced_biometria(	nr_sequencia, 
									nr_prescricao, 
									ie_funcao, 
									cd_pessoa_fisica, 
									dt_atualizacao, 
									nm_usuario, 
									dt_atualizacao_nrec, 
									nm_usuario_nrec, 
									nr_seq_proc) 
			values (	nextval('prescr_proced_biometria_seq'), 
									nr_prescricao_p, 
									ie_funcao_ww, 
									cd_pessoa_fisica_ww, 
									clock_timestamp(), 
									nm_usuario_aux_biometria_p, 
									clock_timestamp(), 
									nm_usuario_p, 
									nr_sequencia_p);
			commit;						
		end if;
	end if;	
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_procedimento_bio (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_biometria_p text, nm_usuario_aux_biometria_p text, nr_seq_participante_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

