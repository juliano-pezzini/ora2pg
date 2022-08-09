-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dependente_protocolo (nr_seq_paciente_p bigint, nr_ciclo_p bigint) AS $body$
DECLARE


nr_prescricao_w		bigint;

C01 CURSOR FOR
	SELECT	nr_prescricao
	from	paciente_atendimento
	where	nr_seq_paciente	= nr_seq_paciente_p
	and	nr_ciclo	= nr_ciclo_p
	and	coalesce(dt_real,dt_prevista) > clock_timestamp()
	and	(nr_prescricao IS NOT NULL AND nr_prescricao::text <> '');


BEGIN

delete	FROM paciente_atendimento
where	nr_seq_paciente	= nr_seq_paciente_p
and	nr_ciclo	= nr_ciclo_p
and	coalesce(nr_prescricao::text, '') = '';

OPEN C01;
LOOP
FETCH C01 into
	nr_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	update	can_ordem_prod
	set	ie_suspensa	= 'S'
	where	nr_prescricao	= nr_prescricao_w;
END LOOP;
CLOSE C01;

update	paciente_atendimento
set	ie_exige_liberacao	= 'S'
where	nr_seq_paciente	= nr_seq_paciente_p
and	(nr_prescricao IS NOT NULL AND nr_prescricao::text <> '')
and	coalesce(dt_real,dt_prevista) > clock_timestamp()
and	nr_ciclo	= nr_ciclo_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dependente_protocolo (nr_seq_paciente_p bigint, nr_ciclo_p bigint) FROM PUBLIC;
