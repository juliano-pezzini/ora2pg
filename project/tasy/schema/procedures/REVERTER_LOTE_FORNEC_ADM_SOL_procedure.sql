-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_lote_fornec_adm_sol ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_sol_p bigint, nr_seq_evento_inv_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_evento_w		prescr_solucao_evento.nr_sequencia%type;
nr_seq_evento_param_w	prescr_solucao_evento.nr_sequencia%type;
nr_seq_motivo_w		prescr_solucao_evento.nr_seq_motivo%type;
nr_seq_horario_w	prescr_mat_hor.nr_sequencia%type;
nr_seq_lote_adm_w	administracao_lote_item.nr_seq_lote_adm%type;
qt_material_w		administracao_lote_item.qt_material%type;
ie_alteracao_w		prescr_solucao_evento.ie_alteracao%type;
ie_abrir_cursor_w	varchar(1)	:= 'N';
ie_troca_frasco_w	varchar(1) := 'N';


--Buscar os horários que devem ser ajustados
c01 CURSOR FOR
SELECT	nr_sequencia
from	prescr_mat_hor
where	nr_prescricao 	= nr_prescricao_p
and		nr_seq_solucao 	= nr_seq_solucao_p
and		nr_etapa_sol	= nr_etapa_sol_p
and 	ie_abrir_cursor_w = 'S';


BEGIN

/*
--Busca o último evento revertido
select	nvl(max(nr_sequencia),0)
into	nr_seq_evento_w
from	prescr_solucao_evento
where	nr_prescricao = nr_prescricao_p
and		nr_seq_solucao = nr_seq_solucao_p
and		ie_tipo_solucao = 1
and		nvl(ie_evento_valido, 'S') = 'N' --O último evento revertido vai estar com este campo = 'N'
and		ie_alteracao <> 6; -- IE_ALTERACAO 6 = Reverter último evento

--Buscar qual foi o tipo da alteração do evento revertido
select	max(ie_alteracao)
into	ie_alteracao_w
from	prescr_solucao_evento
where	nr_sequencia = nr_seq_evento_w;

--Caso tenha revertido um "Reinicio de solução" verifica se a última interrupção que ocacionou este reinicio foi troca de frasco
if	(ie_alteracao_w = 3) then

	--Busca o último evento de interrupção
	select	nvl(max(nr_sequencia),0)
	into	nr_seq_evento_w
	from	prescr_solucao_evento
	where	nr_prescricao = nr_prescricao_p
	and		nr_seq_solucao = nr_seq_solucao_p
	and		ie_tipo_solucao = 1
	and		nvl(ie_evento_valido, 'S') = 'S'
	and		ie_alteracao = 2;

	--Busca o motivo do ultimo evento de interrupção
	select	nvl(max(nr_seq_motivo),0)
	into	nr_seq_motivo_w
	from	prescr_solucao_evento
	where	nr_sequencia = nr_seq_evento_w;

	--Verifica se na interrupção houve troca de frasco
	select	coalesce(max(ie_troca_frasco), 'N')
	into	ie_troca_frasco_w
	from	adep_motivo_interrupcao
	where	nr_sequencia = nr_seq_motivo_w;

end if;
*/
if (nr_seq_evento_inv_p = 0) then
	begin

	select	max(nr_sequencia)
	into STRICT	nr_seq_evento_param_w
	from	prescr_solucao_evento
	where	nr_prescricao = nr_prescricao_p
	and		nr_seq_solucao = nr_seq_solucao_p
	and		ie_alteracao = 54
	and 	ie_evento_valido = 'S';

	end;
else
	begin
	nr_seq_evento_param_w	:= nr_seq_evento_inv_p;
	end;
end if;


--Verifica se ocorreu alguma interrupção anterior ao evento passado onde o motivo seja troca de frasco
select	max(nr_sequencia)
into STRICT	nr_seq_evento_w
from	prescr_solucao_evento
where	nr_sequencia < nr_seq_evento_param_w
and		nr_prescricao = nr_prescricao_p
and		nr_seq_solucao = nr_seq_solucao_p
and		ie_alteracao = 2
and 	ie_evento_valido = 'S';

if (nr_seq_evento_w > 0) then

	--Busca o motivo do ultimo evento de interrupção
	select	coalesce(max(nr_seq_motivo),0)
	into STRICT	nr_seq_motivo_w
	from	prescr_solucao_evento
	where	nr_sequencia = nr_seq_evento_w;

	--Verifica se na interrupção houve troca de frasco
	select	coalesce(max(ie_troca_frasco), 'N')
	into STRICT	ie_troca_frasco_w
	from	adep_motivo_interrupcao
	where	nr_sequencia = nr_seq_motivo_w;

else
    --Verifica se o evento revertido foi o inicio da solução
	select	max(ie_alteracao)
	into STRICT	ie_alteracao_w
	from	prescr_solucao_evento
	where	nr_sequencia = nr_seq_evento_param_w;

end if;

if (ie_troca_frasco_w = 'S') or (ie_alteracao_w in (1,54)) then
		ie_abrir_cursor_w	:= 'S';
end if;

open C01;
loop
fetch C01 into
	nr_seq_horario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	--Busca a qtde de cada horario
	select	coalesce(sum(qt_material),0),
			coalesce(max(nr_seq_lote_adm),0)
	into STRICT	qt_material_w,
			nr_seq_lote_adm_w
	from	administracao_lote_item
	where	nr_seq_horario = nr_seq_horario_w
	and		ie_situacao = 'S';

	if (qt_material_w > 0) and (nr_seq_lote_adm_w > 0) then

		--Atualiza situacao do registro selecionado
		update	administracao_lote_item
		set		ie_situacao = 'N'
		where	nr_seq_horario = nr_seq_horario_w;

		--Decrementa a qtde total do material
		update	administracao_lote_fornec
		set		qt_material = qt_material - qt_material_w
		where	nr_sequencia = nr_seq_lote_adm_w;

		select	coalesce(max(nr_sequencia),-1)
		into STRICT	nr_seq_evento_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_p
		and		nr_seq_solucao = nr_seq_solucao_p
		and		ie_alteracao = 54
		and		ie_evento_valido = 'S';

		update	prescr_solucao_evento
		set		ie_evento_valido = 'N'
		where	nr_sequencia = nr_seq_evento_w;

	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_lote_fornec_adm_sol ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_sol_p bigint, nr_seq_evento_inv_p bigint, nm_usuario_p text) FROM PUBLIC;

