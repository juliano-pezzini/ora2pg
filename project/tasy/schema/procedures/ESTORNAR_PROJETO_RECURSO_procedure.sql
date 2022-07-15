-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_projeto_recurso ( nr_sequencia_p projeto_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_proj_rec_w	projeto_recurso.nr_sequencia%type;
dt_liberacao_w		projeto_recurso.dt_liberacao%type;
dt_aprovacao_w		projeto_recurso.dt_aprovacao%type;
dt_desdobr_aprov_w	projeto_recurso.dt_desdobr_aprov%type;
dt_reprovacao_w		projeto_recurso.dt_reprovacao%type;
nr_seq_aprovacao_w	projeto_recurso.nr_seq_aprovacao%type;

tb_nr_seq_aprovacao_w	dbms_sql.number_table;
nr_aprov_w		integer;

c01 CURSOR(	nr_documento_pc	 processo_aprov_compra.cd_processo_aprov%type ) FOR
	SELECT	nr_sequencia
	from	processo_aprov_compra
	where	nr_documento	= nr_documento_pc
	and	ie_tipo		= 'E';

BEGIN

begin
select	nr_sequencia,
	dt_liberacao,
	dt_aprovacao,
	dt_desdobr_aprov,
	dt_reprovacao,
	nr_seq_aprovacao
into STRICT	nr_seq_proj_rec_w,
	dt_liberacao_w,
	dt_aprovacao_w,
	dt_desdobr_aprov_w,
	dt_reprovacao_w,
	nr_seq_aprovacao_w 
from	projeto_recurso
where	nr_sequencia = nr_sequencia_p;
exception
when no_data_found or too_many_rows then
	nr_seq_proj_rec_w := null;
end;

if (nr_seq_proj_rec_w IS NOT NULL AND nr_seq_proj_rec_w::text <> '') then

	if	((dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') and (coalesce(dt_aprovacao_w::text, '') = '') and (coalesce(dt_desdobr_aprov_w::text, '') = '') and (coalesce(dt_reprovacao_w::text, '') = '') and (nr_seq_aprovacao_w IS NOT NULL AND nr_seq_aprovacao_w::text <> '')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1205734);
	end if;

	update	projeto_recurso
	set	dt_liberacao		 = NULL,
		nm_usuario_lib		 = NULL,
		dt_aprovacao		 = NULL,
		nr_seq_aprovacao	 = NULL,
		nr_seq_proc_aprov	 = NULL,
		dt_desdobr_aprov	 = NULL,
		dt_reprovacao		 = NULL,
		ie_motivo_reprovacao	 = NULL,
		ds_justificativa_reprov	 = NULL,
		nm_usuario_aprov	 = NULL
	where	nr_sequencia		= nr_seq_proj_rec_w;
	
	nr_aprov_w := 1;
	for r_C01_w in C01( nr_seq_proj_rec_w ) loop
		tb_nr_seq_aprovacao_w(nr_aprov_w) := r_C01_w.nr_sequencia;
		nr_aprov_w := nr_aprov_w + 1;
	end loop;
	
	if (tb_nr_seq_aprovacao_w.count > 0) then
		forall i in tb_nr_seq_aprovacao_w.first .. tb_nr_seq_aprovacao_w.last
			delete	FROM processo_aprov_compra
			where	nr_sequencia 	= tb_nr_seq_aprovacao_w(i);
		commit;
		
		forall i in tb_nr_seq_aprovacao_w.first .. tb_nr_seq_aprovacao_w.last
			delete	FROM processo_compra
			where	nr_sequencia 	= tb_nr_seq_aprovacao_w(i);
		commit;
	end if;
	
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_projeto_recurso ( nr_sequencia_p projeto_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

