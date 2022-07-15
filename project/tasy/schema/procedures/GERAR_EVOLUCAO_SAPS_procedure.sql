-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_saps ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w		bigint;
cd_evolucao_w		bigint;
cd_prescritor_w		varchar(10);
nr_atendimento_w		bigint;
cd_pessoa_fisica_w	varchar(10);
dt_liberacao_w		timestamp;
ie_tipo_evolucao_w		varchar(3);
nr_seq_w			varchar(10);
ds_evolucao_w		varchar(32000) := '';
ds_aux_w		varchar(32000) := '';
ds_cabecalho_w		varchar(32000);
ds_tipo_item_w		varchar(80);
ds_observacao_w		varchar(32000);/*david em 16/07/2008 os 99990*/
ds_comentario_w		varchar(32000);
ds_conteudo_w		varchar(32000);
ds_conteudo_w2		varchar(32000);
ds_pos_inicio_rtf_w		bigint;
qt_controle_chr_w		bigint;
ie_gera_comentario_w	varchar(1);
cd_estabelecimento_w	smallint;
ds_diagnostico_w	varchar(255);
ds_diagnosticos_w	varchar(32000);
ie_gera_diagnostico_w	varchar(1);
ie_gera_intervencao_w	varchar(1);
ds_intervencao_w	varchar(255);
ds_intervencoes_w	varchar(32000);
ie_libera_sae_w		varchar(1);
ds_fonte_w		varchar(100);
ds_tam_fonte_w		varchar(10);
nr_tam_fonte_w		integer;
ds_rodape_w		 varchar(255);
ie_situacao_w		varchar(10);
nr_seq_apres_w		bigint;
ds_parametro_w		varchar(2);
ie_rn_w			varchar(1);
ds_evolucao_diag_w	varchar(255);
ds_modelo_w		varchar(255);
ie_should_sign tasy_proj_assin_perfil.ie_assinatura %type;

espacamento_w		varchar(4000) := '';

c01 CURSOR FOR
	SELECT  distinct
		e.nr_sequencia,
		e.ds_tipo_item,
		e.nr_seq_apres
	FROM pe_prescricao r, pe_tipo_item e, pe_item_resultado b, pe_prescr_item_result a, pe_item_examinar c
LEFT OUTER JOIN pe_item_tipo_item d ON (c.nr_sequencia = d.nr_seq_item)
WHERE a.nr_seq_prescr        = nr_sequencia_p and a.nr_seq_result        = b.nr_sequencia and b.ie_situacao        = 'A' and c.ie_situacao        = 'A' and b.nr_seq_item        = c.nr_sequencia and a.nr_seq_prescr = r.nr_sequencia  and d.nr_seq_tipo_item    = e.nr_sequencia
	order 	by e.nr_seq_apres,e.ds_tipo_item;
	
c02 CURSOR FOR
	SELECT	substr(pe_obter_desc_diag(nr_seq_diag,'DI'),1,120) ds,
		substr(obter_desc_sae_evolucao_diag(nr_seq_evolucao_diag),1,255)
	from	pe_prescr_diag
	where	nr_seq_prescr = nr_sequencia_p
	order by ds;
	
c03 CURSOR FOR
	SELECT	substr(obter_desc_intervencoes(nr_seq_proc),1,255) ds
	from	pe_prescr_proc
	where	nr_seq_prescr = nr_sequencia_p
	order by ds;
	


BEGIN



select	coalesce(max(nr_atendimento),0)
into STRICT	nr_atendimento_w
from	pe_prescricao
where	nr_sequencia = nr_sequencia_p;

select	coalesce(max(cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_w;



ie_gera_comentario_w := obter_param_usuario(281, 298, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_comentario_w);

ie_gera_diagnostico_w := obter_param_usuario(281, 300, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_diagnostico_w);
ie_gera_intervencao_w := obter_param_usuario(281, 835, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_intervencao_w);

ie_libera_sae_w := obter_param_usuario(281, 384, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_libera_sae_w);
ds_fonte_w := Obter_Param_Usuario(281, 5, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_fonte_w);
ds_tam_fonte_w := Obter_Param_Usuario(281, 6, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_tam_fonte_w);
	
nr_tam_fonte_w	:= somente_numero(ds_tam_fonte_w)*2;

select	count(*)
into STRICT	qt_registro_w
from	pe_prescr_item_result
where	nr_seq_prescr = nr_sequencia_p;



if (qt_registro_w > 0) then

	select	cd_prescritor,
		nr_atendimento,
		cd_pessoa_fisica,
		CASE WHEN ie_libera_sae_w='S' THEN coalesce(dt_liberacao,clock_timestamp())  ELSE null END ,
		ie_rn
	into STRICT	cd_prescritor_w,
		nr_atendimento_w,
		cd_pessoa_fisica_w,
		dt_liberacao_w,
		ie_rn_w
	from	pe_prescricao
	where	nr_sequencia = nr_sequencia_p;

	select	ie_tipo_evolucao
	into STRICT	ie_tipo_evolucao_w
	from	usuario
	where	nm_usuario = nm_usuario_p;
	
	
	

	if (coalesce(ie_tipo_evolucao_w::text, '') = '') then
		--Tipo de evolucao nao informado para este usuario.
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(264634);
	end if;

	/************************* executar cursor *************************/
	
	select  distinct
		max(substr(obter_desc_mod_sae(r.nr_Seq_modelo),1,250))
	into STRICT	ds_modelo_w
	from    pe_Prescricao r
	where   nr_sequencia        = nr_sequencia_p
	and     ie_situacao        = 'A';
	
	if (ds_modelo_w IS NOT NULL AND ds_modelo_w::text <> '') then
	   ds_modelo_w	:= '\b '||'                                                                                  '||ds_modelo_w ||' \b0 \par \par ';
	end if;

	open c01;
	loop
		fetch c01 into
			nr_seq_w,
			ds_tipo_item_w,
			nr_seq_apres_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		
		ds_parametro_w := Obter_param_Usuario(281, 619, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, 0, ds_parametro_w);
			ds_aux_w	:= obter_resultados_concat(nr_seq_w, nr_sequencia_p);
			
			if (coalesce(ds_parametro_w,'N') = 'S') then
				ds_evolucao_w := ds_evolucao_w 	||	espacamento_w ||wheb_rtf_pck.get_negrito(true)|| ds_tipo_item_w	||wheb_rtf_pck.get_negrito(false)||chr(13) || chr(10) || '	';
				if (ds_aux_w IS NOT NULL AND ds_aux_w::text <> '') then
					ds_evolucao_w	:= ds_evolucao_w||ds_aux_w	|| chr(13) || chr(10);
				end if;
				if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
					ds_evolucao_w:= ds_evolucao_w||ds_observacao_w || chr(13) || chr(10);
				end if;
				espacamento_w := chr(13) || chr(10);
			end if;
			if (coalesce(ds_parametro_w,'N') = 'N') then
				ds_evolucao_w := ds_evolucao_w 	||wheb_rtf_pck.get_negrito(true)|| ds_tipo_item_w	||wheb_rtf_pck.get_negrito(false)|| chr(13) || chr(10) || '	';
				if (ds_aux_w IS NOT NULL AND ds_aux_w::text <> '') then
					ds_evolucao_w	:= ds_evolucao_w||ds_aux_w	|| chr(13) || chr(10);
				end if;
				if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
					ds_evolucao_w:= ds_evolucao_w||ds_observacao_w || chr(13) || chr(10);
				end if;
			end if;	
			
			if (coalesce(ds_parametro_w,'N') = 'T') then
					ds_evolucao_w := ds_evolucao_w 	||wheb_rtf_pck.get_negrito(true)|| ds_tipo_item_w	||wheb_rtf_pck.get_negrito(false)||chr(13) || chr(10) || '	';
				if (ds_aux_w IS NOT NULL AND ds_aux_w::text <> '') then
					ds_evolucao_w	:= ds_evolucao_w||ds_aux_w	|| chr(13) || chr(10);
				end if;
				if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
					ds_evolucao_w:= ds_evolucao_w||ds_observacao_w || chr(13) || chr(10);
				end if;
			end if;
			if (coalesce(ds_parametro_w,'N') = 'C') then
				ds_evolucao_w := ds_evolucao_w 	|| ds_tipo_item_w	|| chr(13) || chr(10) || '	';
				if (ds_aux_w IS NOT NULL AND ds_aux_w::text <> '') then
					ds_evolucao_w	:= ds_evolucao_w||ds_aux_w	|| chr(13) || chr(10);
				end if;
				if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
					ds_evolucao_w:= ds_evolucao_w||ds_observacao_w || chr(13) || chr(10);
				end if;				
			end if;
			if (coalesce(ds_parametro_w, 'N') = 'R') then

				ds_evolucao_w := ds_evolucao_w || ds_aux_w;
				
			end if;
			
			if (coalesce(ds_parametro_w, 'N') = 'O') then

				ds_evolucao_w := ds_evolucao_w || ds_aux_w;
				
				if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
					ds_evolucao_w := ds_evolucao_w || ds_observacao_w || chr(13) || chr(10);
				end if;	
				
			end if;
			
		end loop;					
	close c01;
	
	
	
	if (ie_gera_diagnostico_w = 'S') then
		open c02;
		loop
		fetch c02 into	
			ds_diagnostico_w,
			ds_evolucao_diag_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			if (ds_diagnosticos_w IS NOT NULL AND ds_diagnosticos_w::text <> '') then		
				ds_diagnosticos_w := ds_diagnosticos_w || ', ' || ds_diagnostico_w;
			else
				ds_diagnosticos_w := ds_diagnostico_w;
			end if;
			if (ds_evolucao_diag_w IS NOT NULL AND ds_evolucao_diag_w::text <> '') then
				ds_diagnosticos_w := ds_diagnosticos_w ||' - '||ds_evolucao_diag_w;
			end if;
			end;
		end loop;
		close c02;

		ds_diagnosticos_w := ' \b ' || obter_desc_expressao(287694) || ': ' ||  '\b0 ' || ds_diagnosticos_w;
		ds_evolucao_w	:= ds_evolucao_w || ds_diagnosticos_w || chr(13) || chr(10);
	end if;
	
	
	
	if (ie_gera_intervencao_w = 'S') then
		open c03;
		loop
		fetch c03 into	
			ds_intervencao_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			if (ds_intervencoes_w IS NOT NULL AND ds_intervencoes_w::text <> '') then
				ds_intervencoes_w := ds_intervencoes_w || ', \par ' || ds_intervencao_w;
			else
				ds_intervencoes_w := ds_intervencao_w;
			end if;
			end;
		end loop;
		close c03;

		ds_intervencoes_w := ' \b ' || obter_desc_expressao(292220) || ': ' || '\b0 ' || ds_intervencoes_w;
		ds_evolucao_w	:= ds_evolucao_w || ds_intervencoes_w || chr(13) || chr(10);
	end if;
	
	

	select	nextval('evolucao_paciente_seq')
	into STRICT	cd_evolucao_w
	;
	
	begin
	select	ds_comentario
	into STRICT	ds_comentario_w
	from	pe_prescr_comentario
	where	nr_seq_prescr = nr_sequencia_p;
	exception
	when others then
		ds_comentario_w := null;
	end;
	
		if ((ds_comentario_w IS NOT NULL AND ds_comentario_w::text <> '') and (position('<html' in ds_comentario_w) > 0)) then

		ds_comentario_w := replace(ds_comentario_w, '<p', ' \par <p');
		ds_comentario_w := regexp_replace(ds_comentario_w, '<((/[A-Za-z])|[A-Za-z])[^>]*>', null);
		ds_comentario_w := replace(replace(replace(ds_comentario_w, chr(38) || 'nbsp;', ' '), chr(38) ||'lt;', '<'), chr(38) ||'gt;', '>');

	end if;
	
	if (ie_gera_comentario_w = 'S') and (ds_comentario_w IS NOT NULL AND ds_comentario_w::text <> '') then
		begin
		/*inicio substituir os caracteres chr(13) e chr(10) pelo \par que que representa o enter no rtf*/

		qt_controle_chr_w :=0;
			
		while( position(chr(13) in ds_evolucao_w) > 0 ) and ( qt_controle_chr_w < 100 ) loop
			ds_evolucao_w := replace(ds_evolucao_w,chr(13),'\par ');
			qt_controle_chr_w := qt_controle_chr_w + 1;
		end loop;

		qt_controle_chr_w := 0;

		while( position(chr(10) in ds_evolucao_w) > 0 ) and ( qt_controle_chr_w < 100 ) loop
			ds_evolucao_w := replace(ds_evolucao_w,chr(10),'');
			qt_controle_chr_w := qt_controle_chr_w + 1;
		end loop;
		/*fim substituir os caracteres chr(13) e chr(10) pelo \par que que representa o enter no rtf*/


		/*pega o cabecalho do rtf*/

		ds_cabecalho_w :=	'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Arial;}{\f1\fnil Arial;}}'||
							'{\colortbl ;\red0\green0\blue0;}' ||
							'\viewkind4\uc1\pard\cf1\lang1046\fs20  \fs16 \f1 ';
		ds_pos_inicio_rtf_w := position('lang' in ds_cabecalho_w)+8;
		ds_conteudo_w2 := substr(ds_cabecalho_w,1,ds_pos_inicio_rtf_w) || 'fs20 ';
		/*acrecenta conteudo texto livre*/

		ds_conteudo_w2 := ds_conteudo_w2 ||ds_modelo_w|| ds_evolucao_w;
		/*acrecenta resto do conteudo do rtf*/

		ds_rodape_w	:= '}';
		ds_conteudo_w2	:=	ds_conteudo_w2 || '\par ' || substr(ds_cabecalho_w,ds_pos_inicio_rtf_w,length(ds_cabecalho_w));
		ds_conteudo_w 	:=	ds_conteudo_w2 || '\par ' ||
							Obter_richtext_base(obter_desc_expressao(285523) || ': ', 'E', ds_fonte_w, dividir(nr_tam_fonte_w,2)) ||
							substr(ds_comentario_w,2,length(ds_comentario_w)-1)||ds_rodape_w;
		end;
	else
	
		ds_cabecalho_w	:= '{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fswiss\fcharset0 '||ds_fonte_w||';}}'||
			   '{\*\generator Msftedit 5.41.15.1507;}\viewkind4\uc1\pard\f0\fs'||nr_tam_fonte_w||' ';
			
		ds_rodape_w	:= '}';
		
		

	
		ds_evolucao_w	:= replace(ds_evolucao_w, chr(13)||chr(10), ' \par ');
		ds_conteudo_w := ds_cabecalho_w||ds_modelo_w||ds_evolucao_w||ds_rodape_w;
	end if;
	
	
	
	select	coalesce(max(ie_situacao),'A')
	into STRICT	ie_situacao_w
	from	tipo_evolucao
	where	cd_tipo_evolucao	= 'SAP';
	
	
	if (ie_situacao_w	= 'A') then /*Evitar que gere uma evolucao SAPS quando a mesma esta inativa*/
	
		insert into evolucao_paciente(
			cd_evolucao,
			dt_evolucao,
			ie_tipo_evolucao,
			cd_pessoa_fisica,
			dt_atualizacao,
			nm_usuario,
			nr_atendimento,
			ds_evolucao,
			cd_medico,
			dt_liberacao,
			ie_evolucao_clinica,
			ie_recem_nato,
			ie_situacao,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (cd_evolucao_w,
			clock_timestamp(),
			ie_tipo_evolucao_w,
			cd_pessoa_fisica_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_atendimento_w,
			ds_conteudo_w,
			cd_prescritor_w,
			dt_liberacao_w,
			'SAP',
			coalesce(ie_rn_w,'N'),
			'A',
			clock_timestamp(),
			nm_usuario_p);

			select  max(ie_assinatura)
			into STRICT    ie_should_sign
			from    tasy_proj_assin_perfil
			where   nr_seq_proj = 183
			and     cd_perfil = obter_perfil_ativo;

			if ((ie_should_sign IS NOT NULL AND ie_should_sign::text <> '') and ie_should_sign <> 'N') then
				CALL perform_record_signature(nr_atendimento_w,
					cd_pessoa_fisica_w,
					nm_usuario_p,
					183,
					'EVOLUCAO_PACIENTE',
					cd_evolucao_w,
					29796,
					obter_funcao_ativa,
					'L');
			end if;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_saps ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

