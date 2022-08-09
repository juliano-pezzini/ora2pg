-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_seq_lab_prescricao ( nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_lab_w		bigint := 0;
nr_sequencia_w		bigint;
nr_controle_existe_w	varchar(20);


BEGIN

select	coalesce(max(nr_controle_lab),'A')
into STRICT	nr_controle_existe_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (nr_controle_existe_w = 'A') then

	if (nr_seq_lab_w = 0) then
			lock table lab_seq_geracao in exclusive mode;
			select	coalesce(max(nr_valor_seq),0) + 1,
					max(nr_sequencia)
			into STRICT	nr_seq_lab_w,
				nr_sequencia_w
			from lab_seq_geracao
			where nr_sequencia = (SELECT max(nr_sequencia)
						from lab_seq_geracao);

			update	lab_seq_geracao
			set	nr_valor_seq = nr_seq_lab_w
			where nr_sequencia = nr_sequencia_w;
	end if;

	update	prescr_medica
	set		nr_controle_lab = nr_seq_lab_w
	where	nr_prescricao	= nr_prescricao_p;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_seq_lab_prescricao ( nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
