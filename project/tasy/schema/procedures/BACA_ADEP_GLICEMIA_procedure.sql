-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_adep_glicemia () AS $body$
DECLARE


/* cig */

nr_cig_atend_w	bigint;
ie_status_cig_w	varchar(1);

/* glicemia */

nr_seq_prot_glic_w	bigint;
nr_glicemia_atend_w	bigint;
ie_status_glicemia_w	varchar(1);

/* globais */

nr_atendimento_w	bigint;
nr_seq_glic_atend_w	bigint;

/* obter cig x glicemia */

c01 CURSOR FOR
SELECT	nr_atendimento,
	nr_cig_atend,
	ie_status_cig
from	atendimento_cig
where	coalesce(nr_seq_glicemia::text, '') = ''
group by
	nr_atendimento,
	nr_cig_atend,
	ie_status_cig
order by
	nr_atendimento,
	nr_cig_atend,
	ie_status_cig;

/* obter prot glic x glicemia */

c02 CURSOR FOR
SELECT	nr_atendimento,
	nr_seq_protocolo,
	nr_glicemia_atend,
	ie_status_glicemia
from	atendimento_glicemia
where	coalesce(nr_seq_glicemia::text, '') = ''
group by
	nr_atendimento,
	nr_seq_protocolo,
	nr_glicemia_atend,
	ie_status_glicemia
order by
	nr_atendimento,
	nr_seq_protocolo,
	nr_glicemia_atend,
	ie_status_glicemia;


BEGIN
/* gerar cig x glicemia */

open c01;
loop
fetch c01 into	nr_atendimento_w,
			nr_cig_atend_w,
			ie_status_cig_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	/* gerar glicemia x cig */

	nr_seq_glic_atend_w := gerar_atend_glicemia(nr_atendimento_w, null, null, null, 'BacaAdepGlic', nr_seq_glic_atend_w);

	if (coalesce(nr_seq_glic_atend_w,0) > 0) then
		/* associar cig x glicemia */

		update	atendimento_cig
		set	nr_seq_glicemia	= nr_seq_glic_atend_w
		where	nr_atendimento	= nr_atendimento_w
		and	nr_cig_atend		= nr_cig_atend_w;

		/* atualizar status glicemia */

		update	atend_glicemia
		set	ie_status_glic	= ie_status_cig_w
		where	nr_sequencia		= nr_seq_glic_atend_w;
	end if;

	end;
end loop;
close c01;

/* gerar prot glic x glicemia */

open c02;
loop
fetch c02 into	nr_atendimento_w,
			nr_seq_prot_glic_w,
			nr_glicemia_atend_w,
			ie_status_glicemia_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	/* gerar glicemia x prot glic */

	nr_seq_glic_atend_w := gerar_atend_glicemia(nr_atendimento_w, null, null, nr_seq_prot_glic_w, 'BacaAdepGlic', nr_seq_glic_atend_w);

	if (coalesce(nr_seq_glic_atend_w,0) > 0) then
		/* associar cig x glicemia */

		update	atendimento_glicemia
		set	nr_seq_glicemia	= nr_seq_glic_atend_w
		where	nr_atendimento	= nr_atendimento_w
		and	nr_seq_protocolo	= nr_seq_prot_glic_w
		and	nr_glicemia_atend	= nr_glicemia_atend_w;

		/* atualizar status glicemia */

		update	atend_glicemia
		set	ie_status_glic	= ie_status_glicemia_w
		where	nr_sequencia		= nr_seq_glic_atend_w;
	end if;

	end;
end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_adep_glicemia () FROM PUBLIC;
