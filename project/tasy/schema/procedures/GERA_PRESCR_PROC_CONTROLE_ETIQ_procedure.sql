-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_prescr_proc_controle_etiq ( nr_controle_p bigint, nr_seq_etiqueta_p bigint, ds_zpl_p text, nr_seq_prescr_p bigint, nm_usuario_p text, ie_agrupa_p text default 'N', cd_barras_etiqueta_p text default null, nr_prescricao_p bigint default null) AS $body$
DECLARE


nr_prescricao_w 	bigint;
cd_exame_w  		varchar(20);


BEGIN


if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	nr_prescricao_w		:= nr_prescricao_p;

else
	if (coalesce(ie_agrupa_p,'N') = 'N') then
		select	coalesce(max(nr_prescricao),0)
		into STRICT 	nr_prescricao_w
		from 	prescr_medica
		where 	nr_controle = nr_controle_p;
	else
		select	coalesce(max(a.nr_prescricao),0)
		into STRICT 	nr_prescricao_w
		from 	prescr_medica a, prescr_procedimento b
		where 	a.nr_prescricao = b.nr_prescricao
		and 	b.nr_controle_ext = nr_controle_p;
	end if;
end if;

if (nr_prescricao_w > 0) then

	select	max(e.cd_exame)
	into STRICT	cd_exame_w
	from	exame_laboratorio e,
			prescr_procedimento r
	where	r.nr_prescricao = nr_prescricao_w
	and		r.nr_sequencia = nr_seq_prescr_p
	and		r.nr_seq_exame = e.nr_seq_exame;


	insert into prescr_proc_controle_etiq(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				nr_controle,
				ds_mensagem,
				nr_seq_etiqueta,
				cd_exame,
				nr_seq_prescr,
				cd_barras
				)
		values (
				nextval('prescr_proc_controle_etiq_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_w,
				nr_controle_p,
				ds_zpl_p,
				nr_seq_etiqueta_p,
				cd_exame_w,
				nr_seq_prescr_p,
				cd_barras_etiqueta_p
				);
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_prescr_proc_controle_etiq ( nr_controle_p bigint, nr_seq_etiqueta_p bigint, ds_zpl_p text, nr_seq_prescr_p bigint, nm_usuario_p text, ie_agrupa_p text default 'N', cd_barras_etiqueta_p text default null, nr_prescricao_p bigint default null) FROM PUBLIC;
