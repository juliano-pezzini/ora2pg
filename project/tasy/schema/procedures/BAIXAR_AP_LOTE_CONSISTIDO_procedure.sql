-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_ap_lote_consistido ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_erro_w		varchar(2000) := '';
cd_tipo_baixa_w		integer;
dt_entrada_unidade_w	timestamp;
nr_seq_lote_w		ap_lote.nr_sequencia%type;
ds_material_ww		varchar(2000) := '';

cd_material_w		material.cd_material%type;
ds_material_w		material.ds_material%type;
qt_material_w		double precision;
nr_lote_fornec_w	bigint;
nr_lote_ap_w		ap_lote.nr_sequencia%type;
nr_seq_material_w	prescr_material.nr_sequencia%type;
nr_prescricao_w		prescr_medica.nr_prescricao%type;
cd_local_estoque_w	local_estoque.cd_local_estoque%type;

c01 CURSOR FOR 
	SELECT	b.nr_sequencia 
	from	ap_lote b, 
		prescr_medica a 
	where	a.nr_prescricao = b.nr_prescricao 
	and	coalesce(b.dt_atend_farmacia::text, '') = '' 
	and	b.ie_status_lote not in ('G','S','CA','C','A') 
	and	a.nr_atendimento = nr_atendimento_p;

c02 CURSOR FOR 
	SELECT	cd_material, 
		substr(obter_desc_material(cd_material),1,150) ds_material, 
		qt_material, 
		nr_lote_fornec, 
		nr_lote_ap, 
		nr_seq_material, 
		nr_prescricao, 
		cd_local_estoque 
	from	ap_lote_item_consistido 
	where	nr_lote_ap = nr_seq_lote_w;


BEGIN 
begin 
 
cd_tipo_baixa_w := Obter_param_Usuario(7029, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_tipo_baixa_w);
 
open c01;
loop 
fetch c01 into	 
	nr_seq_lote_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	open c02;
	loop 
	fetch c02 into	 
		cd_material_w, 
		ds_material_w, 
		qt_material_w, 
		nr_lote_fornec_w, 
		nr_lote_ap_w, 
		nr_seq_material_w, 
		nr_prescricao_w, 
		cd_local_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		ds_material_ww := cd_material_w || ' ' || ds_material_w;
		 
		begin 
		select	nr_prescricao 
		into STRICT	nr_prescricao_w 
		from	ap_lote 
		where	nr_sequencia = nr_seq_lote_w;
		 
		select	max(a.dt_entrada_unidade) 
		into STRICT	dt_entrada_unidade_w 
		from	prescr_medica b, 
			atend_paciente_unidade a 
		where	b.nr_prescricao = nr_prescricao_w 
		and	a.nr_atendimento = nr_atendimento_p 
		and	a.cd_setor_atendimento = b.cd_setor_atendimento;
		exception 
		when others then 
			ds_erro_w := substr(sqlerrm(SQLSTATE),1,1900);
		end;
		 
		if (ds_erro_w = '') or (coalesce(ds_erro_w::text, '') = '') then 
			begin 
			CALL baixar_material_barras_lote(	nr_prescricao_w, 
							cd_material_w, 
							qt_material_w, 
							nr_lote_fornec_w, 
							cd_estabelecimento_p, 
							cd_local_estoque_w, 
							dt_entrada_unidade_w, 
							cd_tipo_baixa_w, 
							'S', 
							nr_seq_lote_w, 
							nr_seq_material_w, 
							'B', 
							nm_usuario_p);
			exception 
			when others then 
				ds_erro_w := substr(sqlerrm(SQLSTATE),1,1900);
			end;
		end if;
		 
		if (ds_erro_w <> '') then 
			ds_erro_w := ds_erro_w || ds_material_w;
			exit;
		end if;
		end;
	end loop;
	close c02;
	end;
end loop;
close c01;
 
if (coalesce(ds_erro_w::text, '') = '') then 
	commit;
end if;
exception 
when others then 
	ds_erro_w := substr(sqlerrm(SQLSTATE),1,1900);
end;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_ap_lote_consistido ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

