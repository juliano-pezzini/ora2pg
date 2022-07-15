-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cih_finalizar_copia_cpoe ( nm_usuario_p text, nr_prescricao_p bigint, nr_seq_prescricao_p bigint) AS $body$
DECLARE


nr_dia_util_w	prescr_material.nr_dia_util%type;
nr_seq_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;


BEGIN

select	a.nr_seq_mat_cpoe,
		a.nr_dia_util
into STRICT	nr_seq_cpoe_w,
		nr_dia_util_w
from	prescr_material a
where	a.nr_prescricao = nr_prescricao_p
and		a.nr_sequencia = nr_seq_prescricao_p;


CALL cpoe_atualizar_dias_liberados(	nm_usuario_p,
								nr_seq_cpoe_w,
								nr_prescricao_p,
								nr_dia_util_w);


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cih_finalizar_copia_cpoe ( nm_usuario_p text, nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;

