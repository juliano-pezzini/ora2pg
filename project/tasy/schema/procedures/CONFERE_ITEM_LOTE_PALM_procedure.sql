-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE confere_item_lote_palm ( cd_material_p text, nr_seq_lote_p bigint, nm_usuario_p text, DS_RETORNO_P INOUT text) AS $body$
DECLARE


ora2pg_rowcount int;
nr_sequencia_w					prescr_mat_hor.nr_sequencia%type;
qt_dose_conv_w					prescr_material.qt_dose%type;

cItens CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_horario,
			a.cd_unidade_medida,
			a.cd_unidade_medida_dose,
			a.qt_dose,
			a.cd_material,
			coalesce(a.qt_dispensar_hor,0) qt_dispensar_hor
	from	prescr_mat_hor a
	where (a.cd_material = cd_material_p
	or		substr(obter_dados_material(a.cd_material,'EST'),1,30) = cd_material_p
	or		substr(obter_dados_material(a.cd_material,'GEN'),1,30) = cd_material_p
	or		a.nr_seq_lote_fornec = nr_seq_lote_p)
	and		a.nr_seq_lote	= nr_seq_lote_p;

BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	begin

	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	prescr_mat_hor
	where (cd_material_p = cd_material
	or		cd_material_p = substr(obter_dados_material(cd_material,'EST'),1,30)
	or		cd_material_p = substr(obter_dados_material(cd_material,'GEN'),1,30)
	or		nr_seq_lote_p = nr_seq_lote_fornec)
	and		nr_seq_lote	= nr_seq_lote_p;

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		for cItens_w in cItens loop
			update	prescr_mat_hor
			set  	ie_checado_leito = 'S'
			where 	nr_sequencia = cItens_w.nr_seq_horario;
			GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;

			if ( ora2pg_rowcount > 0) then
				begin
				if (cItens_w.cd_unidade_medida IS NOT NULL AND cItens_w.cd_unidade_medida::text <> '') then
					begin
					if	((cItens_w.cd_unidade_medida = cItens_w.cd_unidade_medida_dose) and (cItens_w.qt_dispensar_hor > 0) and (cItens_w.qt_dose < cItens_w.qt_dispensar_hor)) then
						ds_retorno_p := '1';
					elsif (cItens_w.cd_unidade_medida <> cItens_w.cd_unidade_medida_dose) then
						select	coalesce(obter_conversao_unid_med(cItens_w.cd_material, cItens_w.cd_unidade_medida_dose),0)
						into STRICT	qt_dose_conv_w
						;
						if	(qt_dose_conv_w > 0 AND cItens_w.qt_dose < qt_dose_conv_w) then				
							ds_retorno_p := '2';
						end if;
					end if;
					end;
				end if;
				end;
			end if;
		end loop;
	else
		ds_retorno_p := '3';
	end if;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE confere_item_lote_palm ( cd_material_p text, nr_seq_lote_p bigint, nm_usuario_p text, DS_RETORNO_P INOUT text) FROM PUBLIC;

