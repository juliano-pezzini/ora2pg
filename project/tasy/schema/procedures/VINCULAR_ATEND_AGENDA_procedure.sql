-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_atend_agenda (cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
dt_validade_w			timestamp;
cd_usuario_convenio_w		varchar(30);
nr_doc_convenio_w		varchar(20);
cd_tipo_acomodacao_w		smallint;
cd_plano_convenio_w		varchar(10);
cd_estabelecimento_w		smallint;
ie_gerar_passagem_w		varchar(1) := 'N';
cd_setor_atendimento_w		bigint;
nr_seq_interno_w		bigint := 0;
ie_dados_conv_atual_w		varchar(1) := 'U';
ie_vincular_todas_fases_w	varchar(1);
nr_seq_tratamento_p		rxt_tratamento.nr_sequencia%type;

/* 
cd_tipo_agenda_p 
 
2 = Agenda de Exames 
3, 4 = Agenda de consultas 
5 = Agenda de radioterapia 
*/
 

BEGIN 
 
if (cd_tipo_agenda_p IS NOT NULL AND cd_tipo_agenda_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then 
	 
	ie_dados_conv_atual_w := Obter_Param_Usuario(820, 376, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_dados_conv_atual_w);
	 
	if (cd_tipo_agenda_p = 2) then /* agenda de exames */
 
		if (coalesce(nr_atendimento_p::text, '') = '') then 
			/* desvincular atendimento */
 
			update	agenda_paciente 
			set	nr_atendimento	 = NULL, 
				dt_vinculacao_atendimento  = NULL, 
				nm_usuario	= nm_usuario_p, 
				nm_usuario_vinculo_atend  = NULL 
			where	nr_sequencia 	= nr_seq_agenda_p;
		else 
			/* obter pessoa fisica */
 
			select	coalesce(max(cd_pessoa_fisica),'0') 
			into STRICT	cd_pessoa_fisica_w 
			from	agenda_paciente 
			where	nr_sequencia = nr_seq_agenda_p;
 
			if (cd_pessoa_fisica_w <> '0') then 
				/* obter atendimento */
 
				if (ie_dados_conv_atual_w = 'U') then 
					select	coalesce(max(a.nr_atendimento),0) 
					into STRICT	nr_atendimento_w 
					from	atend_categoria_convenio b, 
						atendimento_paciente a 
					where	b.nr_atendimento	= a.nr_atendimento 
					and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
				elsif (ie_dados_conv_atual_w = 'A') then 
					nr_atendimento_w := nr_atendimento_p;
				end if;
 
				if (nr_atendimento_w > 0) then 
					/* obter dados atendimento */
 
					select	max(b.cd_convenio), 
						max(b.cd_categoria), 
						max(b.dt_validade_carteira), 
						max(b.cd_usuario_convenio), 
						max(b.nr_doc_convenio), 
						max(b.cd_tipo_acomodacao), 
						max(b.cd_plano_convenio) 
					into STRICT	cd_convenio_w, 
						cd_categoria_w, 
						dt_validade_w, 
						cd_usuario_convenio_w, 
						nr_doc_convenio_w, 
						cd_tipo_acomodacao_w, 
						cd_plano_convenio_w 
					from	atend_categoria_convenio b, 
						atendimento_paciente a 
					where	b.nr_atendimento = a.nr_atendimento 
					and	a.nr_atendimento = nr_atendimento_w 
					and	b.nr_seq_interno = (	SELECT	max(x.nr_seq_interno) 
								from	atend_categoria_convenio x 
								where	x.nr_atendimento = nr_atendimento_w);
 
					/* vincular atendimento */
 
					update	agenda_paciente 
					set	nr_atendimento		= nr_atendimento_p, 
						cd_convenio 		= cd_convenio_w, 
						cd_categoria 		= cd_categoria_w, 
						dt_validade_carteira 	= dt_validade_w, 
						cd_usuario_convenio 	= cd_usuario_convenio_w, 
						nr_doc_convenio 		= nr_doc_convenio_w, 
						cd_tipo_acomodacao 	= cd_tipo_acomodacao_w, 
						cd_plano		= cd_plano_convenio_w, 
						nm_usuario		= nm_usuario_p, 
						dt_vinculacao_atendimento = clock_timestamp(), 
						nm_usuario_vinculo_atend	= nm_usuario_p 
					where	nr_sequencia 		= nr_seq_agenda_p;					
				 
					CALL gerar_lancamento_automatico(nr_atendimento_p, null, 493, nm_usuario_p, 0, null, null, null, null, null);
					 
				end if;
			end if;
			 
		end if;
 
	elsif (cd_tipo_agenda_p in (3,4)) then /* agenda de consultas */
 
		if (coalesce(nr_atendimento_p::text, '') = '') then 
			/* desvincular atendimento */
 
			update	agenda_consulta 
			set	nr_atendimento	 = NULL, 
				nm_usuario	= nm_usuario_p, 
				dt_vinculacao_atendimento  = NULL, 
				nm_usuario_vinculo_atend  = NULL 
			where	nr_sequencia 	= nr_seq_agenda_p;
		else 
			/* obter pessoa fisica */
 
			select	coalesce(max(cd_pessoa_fisica),'0'), 
				max(cd_setor_atendimento) 
			into STRICT	cd_pessoa_fisica_w, 
				cd_setor_atendimento_w 
			from	agenda_consulta 
			where	nr_sequencia = nr_seq_agenda_p;
 
			if (cd_pessoa_fisica_w <> '0') then 
				/* obter atendimento */
 
				select	coalesce(max(a.nr_atendimento),0) 
				into STRICT	nr_atendimento_w 
				from	atend_categoria_convenio b, 
					atendimento_paciente a 
				where	b.nr_atendimento	= a.nr_atendimento 
				and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
 
				if (nr_atendimento_w > 0) then 
					/* obter dados atendimento */
 
					select	max(b.cd_convenio), 
						max(b.cd_categoria), 
						max(b.dt_validade_carteira), 
						max(b.cd_usuario_convenio), 
						max(b.nr_doc_convenio), 
						max(b.cd_tipo_acomodacao), 
						max(b.cd_plano_convenio), 
						max(a.cd_estabelecimento) 
					into STRICT	cd_convenio_w, 
						cd_categoria_w, 
						dt_validade_w, 
						cd_usuario_convenio_w, 
						nr_doc_convenio_w, 
						cd_tipo_acomodacao_w, 
						cd_plano_convenio_w, 
						cd_estabelecimento_w 
					from	atend_categoria_convenio b, 
						atendimento_paciente a 
					where	b.nr_atendimento = a.nr_atendimento 
					and	a.nr_atendimento = nr_atendimento_w 
					and	b.nr_seq_interno = (	SELECT	max(x.nr_seq_interno) 
								from	atend_categoria_convenio x 
								where	x.nr_atendimento = nr_atendimento_w);
 
					/* vincular atendimento */
 
					update	agenda_consulta 
					set	nr_atendimento		= nr_atendimento_p, 
						cd_convenio 		= cd_convenio_w, 
						cd_categoria 		= cd_categoria_w, 
						dt_validade_carteira 	= dt_validade_w, 
						cd_usuario_convenio 	= cd_usuario_convenio_w, 
						nr_doc_convenio 	= nr_doc_convenio_w, 
						cd_tipo_acomodacao 	= cd_tipo_acomodacao_w, 
						cd_plano		= cd_plano_convenio_w, 
						nm_usuario		= nm_usuario_p, 
						dt_vinculacao_atendimento = clock_timestamp(), 
						nm_usuario_vinculo_atend	= nm_usuario_p 
					where	nr_sequencia 		= nr_seq_agenda_p;
					 
					ie_gerar_passagem_w	:= coalesce(obter_valor_param_usuario(821, 205, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
					 
					if (ie_gerar_passagem_w = 'S') and (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') then 
						 
						CALL gerar_passagem_setor_atend(nr_atendimento_p, cd_setor_atendimento_w, clock_timestamp(), 'S', nm_usuario_p);
 
						select	coalesce(max(nr_seq_interno),0) 
						into STRICT	nr_seq_interno_w 
						from 	atend_paciente_unidade 
						where 	nr_atendimento	= nr_atendimento_p;
						 
						CALL atend_paciente_unid_afterpost(nr_seq_interno_w,'I',nm_usuario_p);
						 
					end if;
	 
					CALL gerar_lancamento_automatico(nr_atendimento_p, null, 492, nm_usuario_p, 0, null, null, null, null, null);
					 
				end if;
			end if;	
			 
		end if;
	elsif (cd_tipo_agenda_p = 5) then /* agenda de radioterapia*/
 
		ie_vincular_todas_fases_w := Obter_Param_Usuario(3030, 59, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_vincular_todas_fases_w);
		if (coalesce(nr_atendimento_p::text, '') = '') then 
			/* desvincular atendimento */
 
			update	RXT_agenda 
			set	nr_atendimento	 = NULL, 
				nm_usuario	= nm_usuario_p 
			where	nr_sequencia 	= nr_seq_agenda_p;
		else 
			/* vincular atendimento */
 
				 
 
			if (ie_vincular_todas_fases_w = 'S') or (ie_vincular_todas_fases_w = 'P') then 
				 
				select	max(nr_seq_tratamento) 
				into STRICT	nr_seq_tratamento_p 
				from	rxt_agenda 
				where	nr_sequencia	= nr_seq_agenda_p;
				 
				if (nr_seq_tratamento_p IS NOT NULL AND nr_seq_tratamento_p::text <> '') then 
					update	rxt_agenda 
					set	nm_usuario 		= nm_usuario_p, 
						nr_atendimento 		= nr_atendimento_p 
					where	nr_seq_tratamento 	= nr_seq_tratamento_p 
					and	coalesce(nr_atendimento::text, '') = '';
				else 
					update	RXT_agenda 
					set	nr_atendimento		= nr_atendimento_p, 
						nm_usuario		= nm_usuario_p 
					where	nr_sequencia 		= nr_seq_agenda_p;
				end if;
					 
				 
				if (ie_vincular_todas_fases_w = 'P') then 
					update 	rxt_tumor 
					set 	nr_atendimento 	= nr_atendimento_p 
					where 	coalesce(nr_atendimento::text, '') = '' 
					and 	nr_sequencia 	= ( 
						SELECT 	max(nr_seq_tumor) 
						from 	rxt_tratamento 
						where 	nr_sequencia = nr_seq_tratamento_p);
				end if;
			else	 
				update	RXT_agenda 
				set	nr_atendimento		= nr_atendimento_p, 
					nm_usuario		= nm_usuario_p 
				where	nr_sequencia 		= nr_seq_agenda_p;
			end if;
		end if;
 
										 
		 
	elsif (cd_tipo_agenda_p = 6) then 
		if (coalesce(nr_atendimento_p::text, '') = '') then 
			/* desvincular atendimento */
 
			update	agenda_consulta 
			set	nr_atendimento	 = NULL, 
				nm_usuario	= nm_usuario_p, 
				dt_vinculacao_atendimento  = NULL, 
				nm_usuario_vinculo_atend  = NULL 
			where	nr_sequencia 	= nr_seq_agenda_p;
		else 
			update	agenda_consulta 
			set		nr_atendimento	= nr_atendimento_p, 
					nm_usuario	= nm_usuario_p, 
					dt_vinculacao_atendimento = clock_timestamp(), 
					nm_usuario_vinculo_atend	= nm_usuario_p 
			where	nr_sequencia 	= nr_seq_agenda_p;
		end if;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_atend_agenda (cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

