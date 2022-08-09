-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_mat_nao_dispensado ( nr_prescricao_p bigint, nm_usuario_p text, ds_itens_p INOUT text) AS $body$
DECLARE


nr_seq_lote_fornec_w		bigint;
cd_material_w			integer;
nr_cirurgia_w			bigint;
nr_seq_prescricao_w		integer;
qt_devolucao_w			double precision;
qt_mat_disp_w			double precision;
ds_material_w			varchar(255);
cd_perfil_w			integer;
cd_estabelecimento_w		integer;
ie_consiste_mat_w		varchar(15);
ie_achou_w			varchar(1);
qt_material_w			double precision;
qt_dispensacao_w		double precision;
ds_mensagem_w			varchar(2000);
qt_diferenca_w			double precision;
ie_consulta_w			varchar(15);
ie_consolidacao_generico_w	varchar(15);

expressao1_w			varchar(255) := obter_desc_expressao_idioma(773868, null, wheb_usuario_pck.get_nr_seq_idioma);
expressao2_w			varchar(255) := obter_desc_expressao_idioma(722457, null, wheb_usuario_pck.get_nr_seq_idioma);
expressao3_w			varchar(255) := obter_desc_expressao_idioma(698149, null, wheb_usuario_pck.get_nr_seq_idioma);

expressao4_w			varchar(255) := obter_desc_expressao_idioma(773872, null, wheb_usuario_pck.get_nr_seq_idioma);--Encontrado o material
expressao5_w			varchar(255) := obter_desc_expressao_idioma(773873, null, wheb_usuario_pck.get_nr_seq_idioma);
expressao6_w			varchar(255) := obter_desc_expressao_idioma(292766, null, wheb_usuario_pck.get_nr_seq_idioma);--Lote
expressao7_w			varchar(255) := obter_desc_expressao_idioma(773874, null, wheb_usuario_pck.get_nr_seq_idioma);--porém o mesmo não foi previsto na cirurgia
expressao8_w			varchar(255) := obter_desc_expressao_idioma(774510, null, wheb_usuario_pck.get_nr_seq_idioma);--previsto para a cirurgia
expressao9_w			varchar(255) := obter_desc_expressao_idioma(774513, null, wheb_usuario_pck.get_nr_seq_idioma);--registrado como perda
expressao10_w			varchar(255) := obter_desc_expressao_idioma(774514, null, wheb_usuario_pck.get_nr_seq_idioma);--dispensado no PEPO
C01 CURSOR FOR
	SELECT 	cd_material,
		nr_seq_lote_fornec,
		nr_sequencia
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p;

c02 CURSOR FOR
	SELECT	SUM(qt_material) -
		(	obter_qt_dispensada_pepo(nr_prescricao,CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(cd_material)  ELSE cd_material END ,nr_seq_lote_fornec,'D') -
			obter_qt_dispensada_pepo(nr_prescricao,CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(cd_material)  ELSE cd_material END ,nr_seq_lote_fornec,'P')) qt_diferenca,
		cd_material,
		nr_seq_lote_fornec,
		expressao1_w || ' '||cd_material ||' - '||SUBSTR(obter_desc_material(cd_material),1,80)||'.'||CHR(13)||
		expressao2_w || ' '||SUM(qt_material) ||CHR(13)||
		expressao3_w || ' '||(obter_qt_dispensada_pepo(nr_prescricao,cd_material,nr_seq_lote_fornec,'D') -
		obter_qt_dispensada_pepo(nr_prescricao,cd_material,nr_seq_lote_fornec,'P'))  ds_mensagem,
		'A' ie_consulta
	FROM	prescr_material
	WHERE	nr_prescricao 		= nr_prescricao_p
	AND	obter_qt_dispensada_pepo(nr_prescricao,cd_material,nr_seq_lote_fornec,'D') <> 0
	GROUP BY cd_material,nr_seq_lote_fornec,nr_prescricao
	
UNION

	SELECT	SUM(a.qt_material) qt_diferenca,
		a.cd_material,
		a.nr_seq_lote_fornec,
		expressao4_w || ' '||a.cd_material ||' - '||substr(obter_desc_material(a.cd_material),1,80)||','||expressao8_w||', '||chr(13)||
		expressao5_w || ' '||chr(13)||
		expressao6_w || ' '|| a.nr_seq_lote_fornec ds_mensagem,
		'B' ie_consulta
	FROM	prescr_material a
	WHERE	a.nr_prescricao = nr_prescricao_p
	AND	NOT EXISTS (	SELECT	1
					FROM	cirurgia x,
						cirurgia_agente_disp y
					WHERE  	x.nr_cirurgia 	   		= y.nr_cirurgia
					AND	x.nr_prescricao 	   	= a.nr_prescricao
					AND	y.cd_material   	   	= CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(a.cd_material)  ELSE a.cd_material END
					AND	coalesce(y.nr_seq_lote_fornec,0)	= coalesce(a.nr_seq_lote_fornec,0))
	GROUP BY cd_material,nr_seq_lote_fornec,nr_prescricao
	
UNION

	SELECT	coalesce(SUM(b.qt_dispensacao),0),
		CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ,
		b.nr_seq_lote_fornec,
		expressao4_w || ' '||CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ||' - '||substr(obter_desc_material(CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ),1,80)||','||expressao9_w||', '||chr(13)||
		expressao7_w || ' '||chr(13)||
		expressao6_w || ' '||b.nr_seq_lote_fornec ds_mensagem,
		'C' ie_consulta
	FROM	cirurgia a,
		cirurgia_agente_disp b
	WHERE	a.nr_cirurgia			= b.nr_cirurgia
	AND	a.nr_prescricao 		= nr_prescricao_p
	AND	b.ie_operacao			= 'P'
	AND	NOT EXISTS ( 	SELECT 	1
					FROM	prescr_material x
					WHERE  	x.cd_material   		= CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END 
					AND	coalesce(x.nr_seq_lote_fornec,0)	= coalesce(b.nr_seq_lote_fornec,0)
					AND	x.nr_prescricao			= a.nr_prescricao)
	GROUP BY CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ,b.nr_seq_lote_fornec
	
UNION

	SELECT	coalesce(SUM(b.qt_dispensacao),0),
		CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ,
		b.nr_seq_lote_fornec,
		expressao4_w || ' '||CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ||' - '||substr(obter_desc_material(CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ),1,80)||','||expressao10_w||', '||chr(13)||
		expressao7_w || ' '||chr(13)||
		expressao6_w || ' '||b.nr_seq_lote_fornec ds_mensagem,
		'D' ie_consulta
	FROM	cirurgia a,
		cirurgia_agente_disp b
	WHERE	a.nr_cirurgia			= b.nr_cirurgia
	AND	a.nr_prescricao 		= nr_prescricao_p
	AND	b.ie_operacao			= 'D'
	AND	NOT EXISTS ( 	SELECT 	1
					FROM   	prescr_material x
					WHERE  	x.cd_material   		= CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END 
					AND	coalesce(x.nr_seq_lote_fornec,0)	= coalesce(b.nr_seq_lote_fornec,0)
					AND	x.nr_prescricao			= a.nr_prescricao)
	GROUP BY CASE WHEN ie_consolidacao_generico_w='S' THEN Obter_controlador_estoque(b.cd_material)  ELSE b.cd_material END ,b.nr_seq_lote_fornec
	ORDER BY ds_mensagem;



BEGIN





cd_perfil_w		:= wheb_usuario_pck.get_cd_perfil;
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

ie_consiste_mat_w := obter_param_usuario(900, 380, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_consiste_mat_w);
ie_consolidacao_generico_w := obter_param_usuario(872, 152, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_consolidacao_generico_w);

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	select max(nr_cirurgia)
	into STRICT   nr_cirurgia_w
	from   cirurgia
	where  nr_prescricao = nr_prescricao_p;
end if;

if (ie_consiste_mat_w = 'S') then
	open C01;
	loop
	fetch C01 into
		  cd_material_w,
		  nr_seq_lote_fornec_w,
		  nr_seq_prescricao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		select	count(*)
		into STRICT	qt_devolucao_w
		from	prescr_material b,
			prescr_material_devolucao a
		where	b.nr_prescricao 		=  a.nr_prescricao
		and	b.nr_sequencia  		=  a.nr_seq_prescricao
		and     b.cd_material   		=  cd_material_w
		and     coalesce(b.nr_seq_lote_fornec,0)	=  coalesce(nr_seq_lote_fornec_w,0)
		and     b.nr_prescricao 		=  nr_prescricao_p
		AND     a.nr_seq_prescricao 		=  nr_seq_prescricao_w;


		if (qt_devolucao_w = 0) then

			select count(*)
			into STRICT   qt_mat_disp_w
			from   cirurgia_agente_disp
			where  nr_cirurgia 			= nr_cirurgia_w
			and    cd_material 			= cd_material_w
			and    coalesce(nr_seq_lote_fornec,0)	= coalesce(nr_seq_lote_fornec_w,0);

			if (qt_mat_disp_w = 0) then

				select substr(obter_desc_material(cd_material_w),1,255) ds_material
				into STRICT   ds_material_w
				;

			ds_itens_p :=  substr(ds_material_w || ', ' || ds_itens_p,1,255);

			end if;
		end if;
	end loop;
	close c01;
elsif (ie_consiste_mat_w = 'SQ') then
	CALL exclui_w_consistencia_cirurgia(null,nr_prescricao_p);
	open C02;
	loop
	fetch C02 into
		qt_diferenca_w,
		cd_material_w,
		nr_seq_lote_fornec_w,
		ds_mensagem_w,
		ie_consulta_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (ie_consulta_w <> 'A') or (qt_diferenca_w <> 0) then
				CALL gerar_w_consistencia_cirurgia(null,nr_prescricao_p,substr(ds_mensagem_w,1,2000));
		end if;
		end;
	end loop;
	close C02;
end if;

ds_itens_p 	:= substr(ds_itens_p,1,length(ds_itens_p) - 2);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_mat_nao_dispensado ( nr_prescricao_p bigint, nm_usuario_p text, ds_itens_p INOUT text) FROM PUBLIC;
