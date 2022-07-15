-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_lib_servicos_nut ( nr_seq_serv_dia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_nut_serv_w	bigint;
nr_prescr_oral_w	bigint;
nr_prescr_jejum_w	bigint;
nr_prescr_compl_w	bigint;
nr_prescr_enteral_w	bigint;
nr_prescr_npt_adulta_w	bigint;
nr_prescr_npt_ped_w	bigint;
nr_prescr_npt_neo_w	bigint;
nr_prescr_leite_deriv_w	bigint;


C01 CURSOR FOR

	SELECT	a.nr_sequencia
	FROM 	nut_atend_serv_dia a,
		nut_atend_serv_dia_rep b
	WHERE	b.nr_seq_serv_dia = a.nr_sequencia
	AND ( b.nr_prescr_oral(nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w)
		OR b.nr_prescr_jejum in (nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w)
		OR b.nr_prescr_compl in (nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w)
		OR b.nr_prescr_enteral in (nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w)
		OR b.nr_prescr_npt_adulta in (nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w)
		OR b.nr_prescr_npt_ped in (nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w)
		OR b.nr_prescr_npt_neo in (nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w)
		OR b.nr_prescr_leite_deriv in (nr_prescr_oral_w, nr_prescr_jejum_w, nr_prescr_compl_w,nr_prescr_enteral_w,
					nr_prescr_npt_adulta_w, nr_prescr_npt_ped_w, nr_prescr_npt_neo_w,nr_prescr_leite_deriv_w));



BEGIN

if (nr_seq_serv_dia_p IS NOT NULL AND nr_seq_serv_dia_p::text <> '') then

	SELECT  MAX(coalesce(nr_prescr_oral,0)),
		MAX(coalesce(nr_prescr_jejum,0)),
		MAX(coalesce(nr_prescr_compl,0)),
		MAX(coalesce(nr_prescr_enteral,0)),
		MAX(coalesce(nr_prescr_npt_adulta,0)),
		MAX(coalesce(nr_prescr_npt_ped,0)),
		MAX(coalesce(nr_prescr_npt_neo,0)),
		MAX(coalesce(nr_prescr_leite_deriv,0))
	into STRICT	nr_prescr_oral_w,
		nr_prescr_jejum_w,
		nr_prescr_compl_w,
		nr_prescr_enteral_w,
		nr_prescr_npt_adulta_w,
		nr_prescr_npt_ped_w,
		nr_prescr_npt_neo_w,
		nr_prescr_leite_deriv_w
	from 	nut_atend_serv_dia_rep a
	where	nr_seq_serv_dia = nr_seq_serv_dia_p;


	open C01;
	loop
	fetch C01 into
		nr_seq_nut_serv_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		CALL Liberar_Servico_Nutricao( nr_seq_nut_serv_w, nm_usuario_p, 'D');
		end;
	end loop;
	close C01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_lib_servicos_nut ( nr_seq_serv_dia_p bigint, nm_usuario_p text) FROM PUBLIC;

