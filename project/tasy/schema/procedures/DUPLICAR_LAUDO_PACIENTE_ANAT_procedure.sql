-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_laudo_paciente_anat (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w		bigint;
nr_laudo_w			bigint;
nr_seq_laudo_w			bigint;
nr_sequencia_temp_w		bigint;
nr_seq_grupo_questao_w		bigint;
nr_seq_grupo_questao_princ_w	bigint;
nr_seq_questao_item_w		bigint;
ie_duplicar_morfologia_w	varchar(10);

c01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		dt_conclusao, 
		nr_seq_resultado_padrao, 		
		nr_seq_laudo, 
		dt_liberacao
	from  	discussao_laudo_patologia
	where 	nr_seq_laudo = nr_sequencia_p;
	
c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_atendimento, 
		dt_entrada_unidade, 
		nr_laudo, 
		nm_usuario, 
		dt_atualizacao, 
		cd_medico_resp, 
		ds_titulo_laudo, 
		dt_laudo, 
		cd_laudo_padrao, 
		ie_normal, 
		dt_exame, 
		nr_prescricao, 	
		dt_aprovacao, 
		nm_usuario_aprovacao, 
		cd_protocolo, 
		cd_projeto, 
		nr_seq_laudo, 
		nr_seq_prescricao, 
		dt_liberacao, 
		nr_seq_proc, 
		dt_prev_entrega, 
		dt_real_entrega, 
		qt_imagem, 
		dt_envelopado, 
		nr_controle, 
		dt_seg_aprovacao, 
		nm_usuario_seg_aprov, 
		nr_seq_motivo_parada, 
		cd_setor_atendimento, 
		nr_exame, 
		cd_medico_aux, 
		dt_impressao, 
		nm_usuario_digitacao, 
		dt_inicio_digitacao, 
		dt_fim_digitacao, 
		dt_integracao, 
		cd_setor_usuario, 
		nm_medico_solicitante, 
		ie_midia_entregue, 
		cd_tecnico_resp, 
		ie_status_laudo, 
		ds_justificativa, 
		nr_versao, 
		nr_seq_motivo_desap, 
		nm_usuario_copia, 
		dt_copia
	from	laudo_paciente_copia
	where	nr_seq_laudo = nr_sequencia_p;
	
C03 CURSOR FOR
	SELECT	a.nr_sequencia		
	FROM  	laudo_grupo_questao a
	WHERE	a.nr_seq_laudo = nr_sequencia_p;
	
C04 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_item_questao,
		b.nr_sequencia,
		b.dt_liberacao
	FROM  	item_questao_laudo a,
		laudo_questao_item b
	WHERE	a.nr_sequencia = b.nr_seq_item_questao
	AND     b.nr_seq_laudo_grupo = nr_seq_grupo_questao_princ_w
	AND     coalesce(a.ie_situacao,'A') = 'A';
	
c01_w	c01%rowtype;
c02_w	c02%rowtype;
c03_w	c03%rowtype;
c04_w	c04%rowtype;


BEGIN

ie_duplicar_morfologia_w := obter_param_usuario(945, 77, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_duplicar_morfologia_w);

select nextval('laudo_paciente_seq')
into STRICT nr_seq_laudo_w
;

select 	nr_atendimento
into STRICT	nr_atendimento_w
from laudo_paciente
where nr_sequencia = nr_sequencia_p;

select max(nr_laudo) + 1
into STRICT	nr_laudo_w
from laudo_paciente
where nr_atendimento = nr_atendimento_w;


insert into laudo_paciente(	NR_SEQUENCIA,
					NR_ATENDIMENTO,
					DT_ENTRADA_UNIDADE,
					NR_LAUDO,
					NM_USUARIO,
					DT_ATUALIZACAO,
					CD_MEDICO_RESP,
					DS_TITULO_LAUDO,
					DT_LAUDO,
					CD_LAUDO_PADRAO,
					IE_NORMAL,
					DT_EXAME,
					NR_PRESCRICAO,
					CD_PROTOCOLO,
					CD_PROJETO,
					NR_SEQ_PROC,
					NR_SEQ_PRESCRICAO,
					DT_PREV_ENTREGA,
					DT_REAL_ENTREGA,
					QT_IMAGEM,
					nr_exame,
					CD_MEDICO_AUX,
					NR_SEQ_RESULTADO_PADRAO,
					NR_SEQ_GRUPO_MEDIDA,
					DS_INDICACAO_CLINICA_LAUDO)
SELECT	nr_seq_laudo_w,
	NR_ATENDIMENTO,
	DT_ENTRADA_UNIDADE,
	nr_laudo_w,
	nm_usuario_p,
	clock_timestamp(),
	CD_MEDICO_RESP,
	DS_TITULO_LAUDO,
	DT_LAUDO,
	CD_LAUDO_PADRAO,
	IE_NORMAL,
	DT_EXAME,
	NR_PRESCRICAO,
	CD_PROTOCOLO,
	CD_PROJETO,
	NR_SEQ_PROC,
	NR_SEQ_PRESCRICAO,
	DT_PREV_ENTREGA,
	DT_REAL_ENTREGA,
	QT_IMAGEM,
	nr_exame,
	CD_MEDICO_AUX,
	NR_SEQ_RESULTADO_PADRAO,
	NR_SEQ_GRUPO_MEDIDA,
	DS_INDICACAO_CLINICA_LAUDO
from	laudo_paciente
where	nr_sequencia = nr_sequencia_p;

CALL copia_campo_long('LAUDO_PACIENTE','DS_LAUDO','WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
								 'NR_SEQUENCIA='||nr_sequencia_p,'NR_SEQUENCIA='||nr_seq_laudo_w);
								
CALL Vincular_Procedimento_Laudo(nr_seq_laudo_w,'N',nm_usuario_p);

insert into laudo_paciente_imagem(
	   	nr_sequencia,
		nr_seq_imagem, 
		dt_atualizacao, 
		nm_usuario, 
		ds_arquivo_imagem, 
		ds_imagem)
SELECT	nr_seq_laudo_w,
	nr_seq_imagem,
	clock_timestamp(),
	nm_usuario_p,
	ds_arquivo_imagem,
	ds_imagem
from	laudo_paciente_imagem
where	nr_sequencia = nr_sequencia_p;

insert into laudo_paciente_diag(
	   	nr_sequencia,
		cd_doenca, 
		dt_atualizacao, 
		nm_usuario)
SELECT	nr_seq_laudo_w,
	cd_doenca,
	clock_timestamp(),
	nm_usuario_p
from	laudo_paciente_diag
where	nr_sequencia = nr_sequencia_p;

insert into laudo_paciente_medida(
		nr_sequencia,
		nr_seq_laudo, 
		nr_seq_medida, 
		dt_atualizacao, 
		nm_usuario, 
		qt_medida, 
		qt_minimo, 
		qt_maximo, 
		ds_valor_medida, 
		nr_seq_peca_medida)
SELECT	nextval('laudo_paciente_medida_seq'), 
	nr_seq_laudo_w, 
	nr_seq_medida, 
	dt_atualizacao, 
	nm_usuario, 
	qt_medida, 
	qt_minimo, 
	qt_maximo, 
	ds_valor_medida, 
	nr_seq_peca_medida
from	laudo_paciente_medida
where	nr_seq_laudo = nr_sequencia_p;

insert into prescr_proc_peca_laudo(	
		nr_sequencia,
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_peca, 
		nr_seq_laudo)
SELECT		nextval('prescr_proc_peca_laudo_seq'), 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_peca, 
		nr_seq_laudo_w
from		prescr_proc_peca_laudo
where		nr_seq_laudo = nr_sequencia_p;

insert into laudo_paciente_medico(
	nr_sequencia,
	cd_medico, 
	nr_seq_laudo, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	ie_funcao_medico, 
	nr_seq_laudo_medico_classif)
SELECT	nextval('laudo_paciente_medico_seq'), 
	cd_medico, 
	nr_seq_laudo_w, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	ie_funcao_medico, 
	nr_seq_laudo_medico_classif
from	laudo_paciente_medico
where	nr_seq_laudo = nr_sequencia_p;

open c01;
loop
fetch c01 into c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select	nextval('discussao_laudo_patologia_seq')
		into STRICT	nr_sequencia_temp_w
		;
		
		insert into discussao_laudo_patologia(
				nr_sequencia,
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_conclusao, 
				nr_seq_resultado_padrao, 
				--ds_discussao, 
				nr_seq_laudo, 
				dt_liberacao)
		values (	nr_sequencia_temp_w,
				c01_w.dt_atualizacao, 
				c01_w.nm_usuario, 
				c01_w.dt_atualizacao_nrec, 
				c01_w.nm_usuario_nrec, 
				c01_w.dt_conclusao, 
				c01_w.nr_seq_resultado_padrao, 
				--c01_w.ds_discussao, 
				nr_seq_laudo_w, 
				c01_w.dt_liberacao);
		
		CALL copia_campo_long_de_para(	'DISCUSSAO_LAUDO_PATOLOGIA',
						'DS_DISCUSSAO',
						'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
						'NR_SEQUENCIA='||c01_w.nr_sequencia,
						'DISCUSSAO_LAUDO_PATOLOGIA',
						'DS_DISCUSSAO',
						'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
						'NR_SEQUENCIA='||nr_sequencia_temp_w);
						
		insert into Partic_discussao_laudo_pat(	
					NR_SEQUENCIA,
					DT_ATUALIZACAO, 
					NM_USUARIO, 
					DT_ATUALIZACAO_NREC, 
					NM_USUARIO_NREC, 
					NR_SEQ_DISCUSSAO, 
					CD_MEDICO)
			SELECT	nextval('partic_discussao_laudo_pat_seq'),
				DT_ATUALIZACAO, 
				NM_USUARIO, 
				DT_ATUALIZACAO_NREC, 
				NM_USUARIO_NREC, 
				nr_sequencia_temp_w, 
				CD_MEDICO
			from	Partic_discussao_laudo_pat
			where	nr_sequencia = c01_w.nr_sequencia;		
		end;
end loop;
close c01;

insert into laudo_pac_imagem_edicao(
	nr_sequencia,
        ds_arquivo,
        ds_titulo,
	nr_seq_laudo)
SELECT  nextval('laudo_pac_imagem_edicao_seq'),
        ds_arquivo,
        ds_titulo,
	nr_seq_laudo_w
from    laudo_pac_imagem_edicao
where   nr_seq_laudo = nr_sequencia_p;


if (coalesce(ie_duplicar_morfologia_w,'S') = 'S') then
	
	insert into laudo_cido_morfologia(	
		nr_sequencia,
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_laudo, 
		cd_morfologia, 
		nr_seq_prescr_peca,
    NR_SEQ_MORF_DESC_ADIC)
	SELECT	nextval('laudo_cido_morfologia_seq'),
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_laudo_w, 
		cd_morfologia, 
		nr_seq_prescr_peca,
    NR_SEQ_MORF_DESC_ADIC
	from	laudo_cido_morfologia
	where	nr_seq_laudo = nr_sequencia_p;
end if;	
	
insert into laudo_pac_exame_compl(	
		nr_sequencia,
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_exame_compl, 
		nr_seq_laudo)
SELECT	nextval('laudo_pac_exame_compl_seq'), 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	nr_seq_exame_compl, 
	nr_seq_laudo_w
from	laudo_pac_exame_compl
where	nr_seq_laudo = nr_sequencia_p;

open c02;
loop
fetch c02 into c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	
	select	nextval('laudo_paciente_copia_seq')
	into STRICT	nr_sequencia_temp_w
	;
	
	INSERT INTO laudo_paciente_copia(
			NR_SEQUENCIA,
			NR_ATENDIMENTO, 
			DT_ENTRADA_UNIDADE, 
			NR_LAUDO, 
			NM_USUARIO, 
			DT_ATUALIZACAO, 
			CD_MEDICO_RESP, 
			DS_TITULO_LAUDO, 
			DT_LAUDO, 
			CD_LAUDO_PADRAO, 
			IE_NORMAL, 
			DT_EXAME, 
			NR_PRESCRICAO, 		
			DT_APROVACAO, 
			NM_USUARIO_APROVACAO, 
			CD_PROTOCOLO, 
			CD_PROJETO, 
			NR_SEQ_LAUDO, 
			NR_SEQ_PRESCRICAO, 
			DT_LIBERACAO, 
			NR_SEQ_PROC, 
			DT_PREV_ENTREGA, 
			DT_REAL_ENTREGA, 
			QT_IMAGEM, 
			DT_ENVELOPADO, 
			NR_CONTROLE, 
			DT_SEG_APROVACAO, 
			NM_USUARIO_SEG_APROV, 
			NR_SEQ_MOTIVO_PARADA, 
			CD_SETOR_ATENDIMENTO, 
			NR_EXAME, 
			CD_MEDICO_AUX, 
			DT_IMPRESSAO, 
			NM_USUARIO_DIGITACAO, 
			DT_INICIO_DIGITACAO, 
			DT_FIM_DIGITACAO, 
			DT_INTEGRACAO, 
			CD_SETOR_USUARIO, 
			NM_MEDICO_SOLICITANTE, 
			IE_MIDIA_ENTREGUE, 
			CD_TECNICO_RESP, 
			IE_STATUS_LAUDO, 
			DS_JUSTIFICATIVA, 
			NR_VERSAO, 
			NR_SEQ_MOTIVO_DESAP, 
			NM_USUARIO_COPIA, 
			DT_COPIA)
	values (	nr_sequencia_temp_w, 
			c02_w.NR_ATENDIMENTO, 
			c02_w.DT_ENTRADA_UNIDADE, 
			c02_w.NR_LAUDO, 
			c02_w.NM_USUARIO, 
			c02_w.DT_ATUALIZACAO, 
			c02_w.CD_MEDICO_RESP, 
			c02_w.DS_TITULO_LAUDO, 
			c02_w.DT_LAUDO, 
			c02_w.CD_LAUDO_PADRAO, 
			c02_w.IE_NORMAL, 
			c02_w.DT_EXAME, 
			c02_w.NR_PRESCRICAO, 	
			c02_w.DT_APROVACAO, 
			c02_w.NM_USUARIO_APROVACAO, 
			c02_w.CD_PROTOCOLO, 
			c02_w.CD_PROJETO, 
			NR_SEQ_LAUDO_w,
			c02_w.NR_SEQ_PRESCRICAO, 
			c02_w.DT_LIBERACAO, 
			c02_w.NR_SEQ_PROC, 
			c02_w.DT_PREV_ENTREGA, 
			c02_w.DT_REAL_ENTREGA, 
			c02_w.QT_IMAGEM, 
			c02_w.DT_ENVELOPADO, 
			c02_w.NR_CONTROLE, 
			c02_w.DT_SEG_APROVACAO, 
			c02_w.NM_USUARIO_SEG_APROV, 
			c02_w.NR_SEQ_MOTIVO_PARADA, 
			c02_w.CD_SETOR_ATENDIMENTO, 
			c02_w.NR_EXAME, 
			c02_w.CD_MEDICO_AUX, 
			c02_w.DT_IMPRESSAO, 
			c02_w.NM_USUARIO_DIGITACAO, 
			c02_w.DT_INICIO_DIGITACAO, 
			c02_w.DT_FIM_DIGITACAO, 
			c02_w.DT_INTEGRACAO, 
			c02_w.CD_SETOR_USUARIO, 
			c02_w.NM_MEDICO_SOLICITANTE, 
			c02_w.IE_MIDIA_ENTREGUE, 
			c02_w.CD_TECNICO_RESP, 
			c02_w.IE_STATUS_LAUDO, 
			c02_w.DS_JUSTIFICATIVA, 
			c02_w.NR_VERSAO, 
			c02_w.NR_SEQ_MOTIVO_DESAP, 
			c02_w.NM_USUARIO_COPIA, 
			c02_w.DT_COPIA);
	
	CALL copia_campo_long_de_para(	'LAUDO_PACIENTE_COPIA',
					'DS_LAUDO',
					'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
					'NR_SEQUENCIA='||c02_w.nr_sequencia,
					'LAUDO_PACIENTE_COPIA',
					'DS_LAUDO',
					'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
					'NR_SEQUENCIA='||nr_sequencia_temp_w);	
	end;
end loop;
close c02;

insert into laudo_medida_peca(
		nr_sequencia,
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_tipo_medida, 
		nr_seq_peca, 
		nr_seq_laudo)
SELECT	nextval('laudo_medida_peca_seq'), 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	nr_seq_tipo_medida, 
	nr_seq_peca, 
	nr_seq_laudo_w
from	laudo_medida_peca 
where	nr_seq_laudo = nr_sequencia_p;

if (nr_seq_laudo_w IS NOT NULL AND nr_seq_laudo_w::text <> '') then
	open c03;
	loop
	fetch c03 into c03_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		
		select	nextval('laudo_grupo_questao_seq')
		into STRICT	nr_seq_grupo_questao_w
		;
		
		insert into laudo_grupo_questao(nr_sequencia,
						nr_seq_laudo, 
						nr_seq_grupo_questao, 
						dt_liberacao, 
						nr_seq_peca,
						dt_atualizacao,
						dt_atualizacao_nrec, 
						nm_usuario, 
						nm_usuario_nrec)
					SELECT	nr_seq_grupo_questao_w,
						nr_seq_laudo_w,
						nr_seq_grupo_questao, 
						dt_liberacao, 
						nr_seq_peca,
						dt_atualizacao,
						dt_atualizacao_nrec, 
						nm_usuario, 
						nm_usuario_nrec
					from	laudo_grupo_questao
					where	nr_sequencia = c03_w.nr_sequencia;
		
		nr_seq_grupo_questao_princ_w	:= c03_w.nr_sequencia;
		
		open c04;
		loop
		fetch c04 into c04_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
			begin
			
			select	nextval('laudo_questao_item_seq')
			into STRICT	nr_seq_questao_item_w
			;
			
			insert into laudo_questao_item(	nr_sequencia,
							dt_atualizacao,
							dt_atualizacao_nrec, 
							nm_usuario,  
							nm_usuario_nrec, 
							nr_seq_laudo_grupo, 
							nr_seq_item_questao, 
							dt_liberacao)
						SELECT	nr_seq_questao_item_w,	
							dt_atualizacao,
							dt_atualizacao_nrec, 
							nm_usuario,  
							nm_usuario_nrec,
							nr_seq_grupo_questao_w,
							c04_w.nr_seq_item_questao,
							c04_w.dt_liberacao
						from	laudo_questao_item
						where	nr_sequencia = c04_w.nr_sequencia;
			
			CALL copia_campo_long_de_para(	'LAUDO_QUESTAO_ITEM',
							'DS_TEXTO',
							'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
							'NR_SEQUENCIA='||c04_w.nr_sequencia,
							'LAUDO_QUESTAO_ITEM',
							'DS_TEXTO',
							'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
							'NR_SEQUENCIA='||nr_seq_questao_item_w);				
			end;
		end loop;
		close c04;
		
		end;
	end loop;
	close c03;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_laudo_paciente_anat (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

