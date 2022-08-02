-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_pag_aprop_copart () AS $body$
DECLARE


nr_seq_pagador_w	pls_contrato_pagador.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_coparticipacao_aprop,
		c.nr_seq_pagador,
		a.nr_seq_centro_apropriacao
	from	pls_conta_copartic_aprop a,
		pls_conta_coparticipacao b,
		pls_segurado c
	where	b.nr_sequencia = a.nr_seq_conta_coparticipacao
	and	c.nr_sequencia = b.nr_seq_segurado
	and	coalesce(a.nr_seq_pagador::text, '') = ''
	and	(b.nr_seq_pagador IS NOT NULL AND b.nr_seq_pagador::text <> '');

BEGIN

for r_c01_w in c01 loop
	begin
	select	max(nr_seq_pagador_item)
	into STRICT	nr_seq_pagador_w
	from	pls_pagador_item_mens
	where	nr_seq_pagador = r_c01_w.nr_seq_pagador
	and	ie_tipo_item = '3'
	and	nr_seq_centro_apropriacao = r_c01_w.nr_seq_centro_apropriacao;
	
	if (coalesce(nr_seq_pagador_w::text, '') = '') then
		select	max(nr_seq_pagador_item)
		into STRICT	nr_seq_pagador_w
		from	pls_pagador_item_mens
		where	nr_seq_pagador = r_c01_w.nr_seq_pagador
		and	ie_tipo_item = '3'
		and	coalesce(nr_seq_centro_apropriacao::text, '') = '';
		
		if (coalesce(nr_seq_pagador_w::text, '') = '') then
			nr_seq_pagador_w := r_c01_w.nr_seq_pagador;
		end if;
	end if;
	
	update	pls_conta_copartic_aprop
	set	nr_seq_pagador = nr_seq_pagador_w
	where	nr_sequencia = r_c01_w.nr_seq_coparticipacao_aprop;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_pag_aprop_copart () FROM PUBLIC;

