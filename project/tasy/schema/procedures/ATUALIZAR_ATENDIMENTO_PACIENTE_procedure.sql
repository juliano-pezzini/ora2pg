-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_atendimento_paciente ( nr_atendimento_p bigint) AS $body$
DECLARE


nr_sequencia_w			bigint	:= 0;
nr_reg_Atual_w			bigint	:= 0;
dt_entrada_unidade_w		timestamp;
ie_classif_setor_w		smallint;
nr_seq_atual_w			bigint;
nr_seq_int_w			bigint;

C001 CURSOR FOR
SELECT
	a.dt_entrada_unidade,
	b.cd_classif_setor,
	a.nr_sequencia
from 	setor_atendimento b, atend_paciente_unidade a
where nr_atendimento 		= nr_atendimento_p
  and a.cd_setor_atendimento 	= b.cd_setor_atendimento
order by dt_entrada_unidade;


BEGIN
OPEN C001;
LOOP
FETCH C001 INTO
	dt_entrada_unidade_w,
	ie_classif_setor_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c001 */
	begin
	nr_seq_atual_w		:= nr_sequencia_w;
	if (ie_classif_setor_w  (3,4,8)) then
		nr_seq_int_w	:= nr_sequencia_w;
	end if;
	end;
end loop;
close c001;

update atendimento_paciente
set 	nr_seq_Unid_atual = nr_seq_atual_w,
	nr_seq_Unid_int	= nr_seq_int_w
where nr_atendimento = nr_atendimento_p;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_atendimento_paciente ( nr_atendimento_p bigint) FROM PUBLIC;

