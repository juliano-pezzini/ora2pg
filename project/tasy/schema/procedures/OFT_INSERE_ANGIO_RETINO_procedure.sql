-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_insere_angio_retino ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, nr_seq_consulta_form_ant_p bigint, vListaAngioRetino strRecTypeFormOft) AS $body$
DECLARE


nr_sequencia_w				oft_angio_retino.nr_sequencia%type;
dt_exame_w					oft_angio_retino.dt_registro%type;
ds_observacao_w			oft_angio_retino.ds_observacao%type;	
ds_angiografia_w			oft_angio_retino.ds_angiografia%type;
ds_retinografia_w			oft_angio_retino.ds_retinografia%type;
ds_oe_angiografia_w		oft_angio_retino.ds_oe_angiografia%type;
ds_oe_retinografia_w		oft_angio_retino.ds_oe_retinografia%type;
cd_profissional_w			oft_angio_retino.cd_profissional%type;	
ie_tipo_registro_w      oft_angio_retino.ie_tipo_registro%type := 'A';	
nm_usuario_w				usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ie_registrado_w			varchar(1) := 'N';
ds_erro_w					varchar(4000);
											
BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaAngioRetino.count > 0) then
	for i in 1..vListaAngioRetino.count loop
		begin
		
		if (vListaAngioRetino[i].nr_seq_visao = 86068) then
			ie_tipo_registro_w := 'A';
		elsif (vListaAngioRetino[i].nr_seq_visao = 101309) then
			ie_tipo_registro_w := 'R';
		end if;
		
		if (vListaAngioRetino[i](.ds_valor IS NOT NULL AND .ds_valor::text <> '')) or (vListaAngioRetino[i](.nr_valor IS NOT NULL AND .nr_valor::text <> '')) then

			case upper(vListaAngioRetino[i].nm_campo)
				when 'CD_PROFISSIONAL' then
					cd_profissional_w					:= vListaAngioRetino[i].ds_valor;
				when 'DT_REGISTRO' then
					dt_exame_w 							:= pkg_date_utils.get_DateTime(vListaAngioRetino[i].ds_valor);
				when 'DS_OBSERVACAO' then
					ds_observacao_w					:= vListaAngioRetino[i].ds_valor;
					ie_registrado_w					:= 'S';
				when 'DS_ANGIOGRAFIA' then
					ds_angiografia_w 					:= vlistaangioretino[i].ds_valor;
					ie_registrado_w					:= 'S';
				when 'DS_RETINOGRAFIA' then
					ds_retinografia_w 				:= vListaAngioRetino[i].ds_valor;
					ie_registrado_w					:= 'S';
				when 'DS_OE_ANGIOGRAFIA' then
					ds_oe_angiografia_w 				:= vListaAngioRetino[i].ds_valor;
					ie_registrado_w					:= 'S';
				when 'DS_OE_RETINOGRAFIA' then
					ds_oe_retinografia_w 			:= vListaAngioRetino[i].ds_valor;
					ie_registrado_w					:= 'S';
				else
					null;	
			end case;	
		end if;	
	end;
	end loop;
	
	select	max(nr_sequencia)
	into STRICT		nr_sequencia_w
	from		oft_angio_retino
	where		nr_seq_consulta_form = nr_seq_consulta_form_p
	and		nr_seq_consulta		= nr_seq_consulta_p
	and		coalesce(dt_liberacao::text, '') = ''
   and      coalesce(ie_tipo_registro,'A') = ie_tipo_registro_w
	and		nm_usuario				= nm_usuario_w;
	
	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		update	oft_angio_retino
		set		dt_atualizacao			=	clock_timestamp(),
					nm_usuario				=	nm_usuario_w,
					cd_profissional		= coalesce(cd_profissional_w,cd_profissional),	
					dt_registro				=	coalesce(dt_exame_w,dt_registro),
					ds_retinografia		=	ds_retinografia_w,
					ds_angiografia			=	ds_angiografia_w,
					ds_observacao			=	ds_observacao_w,
					ds_oe_angiografia		=	ds_oe_angiografia_w,
					ds_oe_retinografia	=	ds_oe_retinografia_w
		where		nr_sequencia			=	nr_sequencia_w;	
		CALL wheb_usuario_pck.set_ie_commit('S');
	else
		if (ie_registrado_w = 'S') then
			CALL wheb_usuario_pck.set_ie_commit('S');
			select	nextval('oft_angio_retino_seq')
			into STRICT		nr_sequencia_w	
			;

			insert	into oft_angio_retino(	nr_sequencia,
														dt_atualizacao, 
														nm_usuario, 
														dt_atualizacao_nrec, 
														nm_usuario_nrec, 
														cd_profissional, 
														dt_registro,
														nr_seq_consulta, 
														ie_situacao,
														ds_retinografia, 
														ds_angiografia, 
														ds_observacao, 
														ds_oe_angiografia, 
														ds_oe_retinografia,
                                          ie_tipo_registro,
														nr_seq_consulta_form)
			values (	nr_sequencia_w, 
														clock_timestamp(), 
														nm_usuario_w, 
														clock_timestamp(), 
														nm_usuario_w, 
														coalesce(cd_profissional_w,obter_pf_usuario(nm_usuario_w,'C')), 
														coalesce(dt_exame_w,clock_timestamp()), 
														nr_seq_consulta_p,
														'A',
														ds_retinografia_w, 
														ds_angiografia_w, 
														ds_observacao_w, 
														ds_oe_angiografia_w, 
														ds_oe_retinografia_w,
                                          ie_tipo_registro_w,
														nr_seq_consulta_form_p);
														
			if (coalesce(nr_seq_consulta_form_ant_p,0) > 0) then
				insert	into oft_consulta_imagem(	nr_sequencia,
																dt_atualizacao, 
																nm_usuario, 
																dt_atualizacao_nrec, 
																nm_usuario_nrec, 
																ds_titulo, 
																ds_arquivo, 
																ds_arquivo_backup, 
																nr_seq_angio_retino)
																SELECT	nextval('oft_consulta_imagem_seq'),
																			clock_timestamp(), 
																			nm_usuario_w, 
																			clock_timestamp(), 
																			nm_usuario_w, 
																			ds_titulo, 
																			ds_arquivo, 
																			ds_arquivo_backup, 
																			nr_sequencia_w
																from		oft_consulta_imagem a,
																			oft_angio_retino b
																where		a.nr_seq_angio_retino 	= 	b.nr_sequencia
																and		b.nr_seq_consulta_form	= 	nr_seq_consulta_form_ant_p
                                                and      coalesce(b.ie_tipo_registro,'A') = ie_tipo_registro_w
																and		b.nr_seq_consulta			=	nr_seq_consulta_p;
																
				insert	into oft_imagem_exame(	nr_sequencia,
																dt_atualizacao, 
																nm_usuario, 
																dt_atualizacao_nrec, 
																nm_usuario_nrec, 
																ds_titulo, 
																ds_arquivo, 
																nr_seq_consulta, 
																ie_lado, 
																nr_seq_angio_retino, 
																ie_situacao, 
																cd_profissional)
													SELECT	nextval('oft_imagem_exame_seq'),
																clock_timestamp(), 
																nm_usuario_w, 
																clock_timestamp(), 
																nm_usuario_w, 
																ds_titulo, 
																ds_arquivo, 
																nr_seq_consulta_p, 
																ie_lado, 
																nr_sequencia_w, 
																'A', 
																coalesce(cd_profissional_w,obter_pf_usuario(nm_usuario_w,'C'))
													from		oft_imagem_exame a,
																oft_angio_retino b
													where		a.nr_seq_angio_retino 	= 	b.nr_sequencia
													and		b.nr_seq_consulta_form	= 	nr_seq_consulta_form_ant_p
                                       and      coalesce(b.ie_tipo_registro,'A') = ie_tipo_registro_w
													and		b.nr_seq_consulta			=	nr_seq_consulta_p;																
			end if;															
		end if;												
	end if;												
end if;	

exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
	update	OFT_CONSULTA_FORMULARIO
	set		ds_stack			=	substr(dbms_utility.format_call_stack||ds_erro_w,1,4000)
	where		nr_sequencia	= 	nr_seq_consulta_form_p;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_insere_angio_retino ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, nr_seq_consulta_form_ant_p bigint, vListaAngioRetino strRecTypeFormOft) FROM PUBLIC;
