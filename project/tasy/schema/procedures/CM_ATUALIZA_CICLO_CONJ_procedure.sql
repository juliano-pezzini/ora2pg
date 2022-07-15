-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_atualiza_ciclo_conj ( nr_seq_conj_p bigint, nr_seq_ciclo_p bigint, nm_usuario_p text, nm_usuario_orig_p text default null, nm_usuario_prepa_p text default null) AS $body$
DECLARE

			
nr_seq_embalagem_w	cm_classif_embalagem.nr_sequencia%type;
qt_dia_validade_w	cm_classif_embalagem.qt_dia_validade%type;
qt_dia_validade_ww	cm_classif_embalagem.qt_dia_validade%type;


BEGIN

update	cm_conjunto_cont
set	nr_seq_ciclo = nr_seq_ciclo_p,
	nm_usuario = nm_usuario_p,
    nm_usuario_origem = coalesce(nm_usuario_orig_p,nm_usuario_origem)
where	nr_sequencia = nr_seq_conj_p;


if (nm_usuario_prepa_p IS NOT NULL AND nm_usuario_prepa_p::text <> '') then
	
	update cm_ciclo
	set nm_usuario_preparo = nm_usuario_prepa_p
	where nr_sequencia = nr_seq_ciclo_p;
	
end if;


select	max(nr_seq_embalagem)
into STRICT	nr_seq_embalagem_w
from	cm_conjunto_cont
where	nr_sequencia = nr_seq_conj_p;

select	coalesce(max(qt_dia_validade), 0)
into STRICT	qt_dia_validade_w
from	cm_classif_embalagem
where	nr_sequencia = nr_seq_embalagem_w;

if (qt_dia_validade_w > 0) then

	select	coalesce(max(qt_dia_validade), 0)
	into STRICT	qt_dia_validade_ww
	from	cm_classif_embalagem
	where	nr_sequencia = nr_seq_embalagem_w
	and	coalesce(ie_indeterminado, 'N') = 'S';
	
	if (qt_dia_validade_ww = 0) then
		update	cm_conjunto_cont
		set	dt_validade = (clock_timestamp() + qt_dia_validade_w)
		where	nr_sequencia = nr_seq_conj_p;
	else
		update	cm_conjunto_cont
		set	dt_validade  = NULL,
			ie_indeterminado = 'S'
		where	nr_sequencia = nr_seq_conj_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_atualiza_ciclo_conj ( nr_seq_conj_p bigint, nr_seq_ciclo_p bigint, nm_usuario_p text, nm_usuario_orig_p text default null, nm_usuario_prepa_p text default null) FROM PUBLIC;

