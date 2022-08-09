-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_liberar_susp_atend ( nr_seq_suspensao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Preencher a data de liberação da suspensão de atendimento do participante e atualizar situação do mesmo
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_participante_w		mprev_suspensao_atend.nr_seq_participante%type;
dt_inicio_w			mprev_suspensao_atend.dt_inicio%type;
ie_tipo_w			mprev_motivo_susp_atend.ie_tipo%type;
nr_seq_motivo_w			mprev_suspensao_atend.nr_seq_motivo%type;
qt_nao_finalizada_w		bigint;


BEGIN

select	nr_seq_participante,
	dt_inicio,
	nr_seq_motivo
into STRICT	nr_seq_participante_w,
	dt_inicio_w,
	nr_seq_motivo_w
from 	mprev_suspensao_atend
where 	nr_sequencia = nr_seq_suspensao_p;

select	count(1)
into STRICT	qt_nao_finalizada_w
from	mprev_suspensao_atend a
where	a.nr_seq_participante = nr_seq_participante_w
and	coalesce(a.dt_termino::text, '') = ''
and	nr_sequencia <> nr_seq_suspensao_p;

if (qt_nao_finalizada_w = 0) then
	update 	mprev_suspensao_atend
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		dt_liberacao = clock_timestamp()
	where 	nr_sequencia = nr_seq_suspensao_p;

	update	mprev_participante
	set	ie_situacao = 'S',
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where 	nr_sequencia = nr_seq_participante_w;

	if (nr_seq_motivo_w IS NOT NULL AND nr_seq_motivo_w::text <> '') then
		select	ie_tipo
		into STRICT	ie_tipo_w
		from 	mprev_motivo_susp_atend
		where	nr_sequencia = nr_seq_motivo_w;

		if (ie_tipo_w = 'INT') then
			update	mprev_participante
			set	ie_internacao =	'I'
			where 	nr_sequencia = nr_seq_participante_w;
		end if;
	end if;
else
	/*Só é possível liberar esta suspensão caso as demais do participante já tenham data de fim.*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(412299);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_liberar_susp_atend ( nr_seq_suspensao_p bigint, nm_usuario_p text) FROM PUBLIC;
