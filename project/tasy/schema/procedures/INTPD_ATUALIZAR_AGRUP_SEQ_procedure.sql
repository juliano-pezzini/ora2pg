-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_atualizar_agrup_seq ( nr_seq_agrupador_p bigint default null) AS $body$
DECLARE


ie_status_w		intpd_fila_transmissao.ie_status%type;

ie_existe_w		varchar(1);

nr_seq_evento_sistema_w	intpd_fila_transmissao.nr_seq_evento_sistema%type;
nr_seq_agrupador_w	intpd_fila_transmissao.nr_seq_agrupador%type;
nr_seq_agrupador_ww	intpd_fila_transmissao.nr_seq_agrupador%type;

nr_seq_dependencia_w	intpd_fila_transmissao.nr_sequencia%type;

qt_reg_w			bigint;

c00 CURSOR FOR
SELECT	a.nr_seq_agrupador
from	intpd_fila_transmissao a
where	a.ie_envio_recebe in ('E', 'C')
and	(a.nr_seq_agrupador IS NOT NULL AND a.nr_seq_agrupador::text <> '')
and	a.nr_seq_agrupador = coalesce(nr_seq_agrupador_ww, a.nr_seq_agrupador)
and	coalesce(a.ie_status,'X') not in ('E','S','AEX')
group by	a.nr_seq_agrupador;

c00_w	c00%rowtype;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_dependencia,
	b.nr_seq_evento,
	b.nr_seq_projeto_xml,
	a.nr_seq_documento,
	a.ie_evento
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.ie_envio_recebe in ('E', 'C')
and	a.nr_seq_agrupador = c00_w.nr_seq_agrupador
order by	a.nr_sequencia;

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	'P' ie_new_status
from	intpd_fila_transmissao a
where	nr_seq_agrupador = c00_w.nr_seq_agrupador
and	nr_seq_dependencia = c01_w.nr_sequencia
and	ie_status not in ('E','S','P','R','A')
and	ie_status_w = 'S'

union all

SELECT	a.nr_sequencia,
	'AP' ie_new_status
from	intpd_fila_transmissao a
where	nr_seq_agrupador = c00_w.nr_seq_agrupador
and	nr_seq_dependencia = c01_w.nr_sequencia
and	ie_status not in ('E','S','AP','R','A')
and	ie_status_w <> 'S';

c02_w	c02%rowtype;



BEGIN
if (nr_seq_agrupador_p > 0) then
	nr_seq_agrupador_ww	:=	nr_seq_agrupador_p;
end if;

open c00;
loop
fetch c00 into	
	c00_w;
EXIT WHEN NOT FOUND; /* apply on c00 */
	begin		
	open c01;
	loop
	fetch c01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_seq_dependencia_w	:=	null;
		
		begin
		select	'S'
		into STRICT	ie_existe_w
		from	intpd_evento_superior
		where	nr_seq_evento = c01_w.nr_seq_evento  LIMIT 1;		
		exception
		when others then
			ie_existe_w	:=	'N';
		end;
		
		if (ie_existe_w = 'S') then
			begin
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_dependencia_w
			from	intpd_fila_transmissao a,
				intpd_eventos_sistema b
			where	a.nr_seq_evento_sistema = b.nr_sequencia
			and	a.nr_seq_agrupador = c00_w.nr_seq_agrupador
			and	a.nr_sequencia < c01_w.nr_sequencia
			and	coalesce(a.ie_status, 'X') not in ('S')
			and	exists (	SELECT	1
					from	intpd_evento_superior x
					where	x.nr_seq_evento = c01_w.nr_seq_evento
					and	x.nr_seq_evento_sup = b.nr_seq_evento
					and	coalesce(x.nr_seq_evento_sistema, b.nr_sequencia) = b.nr_sequencia);			
			end;
		elsif (c01_w.nr_seq_dependencia IS NOT NULL AND c01_w.nr_seq_dependencia::text <> '') then
			update	intpd_fila_transmissao
			set	nr_seq_dependencia  = NULL
			where	nr_sequencia = c01_w.nr_sequencia;		
		end if;
		
		if (coalesce(nr_seq_dependencia_w::text, '') = '') and (obter_se_integracao_ish(c01_w.nr_seq_projeto_xml) = 'S') then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_dependencia_w
			from	intpd_fila_transmissao a,
				intpd_eventos_sistema b
			where	a.nr_seq_evento_sistema = b.nr_sequencia
			and	a.ie_evento = c01_w.ie_evento
			and	coalesce(a.ie_status, 'X') not in ('S')
			and	a.nr_seq_agrupador = c00_w.nr_seq_agrupador
			and	obter_se_integracao_ish(b.nr_seq_projeto_xml) = 'S'
			and	a.nr_sequencia < c01_w.nr_sequencia;			
		end if;		
		
		if (nr_seq_dependencia_w IS NOT NULL AND nr_seq_dependencia_w::text <> '') and (coalesce(c01_w.nr_seq_dependencia, 0) <> nr_seq_dependencia_w) then
			update	intpd_fila_transmissao
			set	nr_seq_dependencia = nr_seq_dependencia_w
			where	nr_sequencia = c01_w.nr_sequencia;
		end if;
		end;
	end loop;
	close c01;	
		
	open c01;
	loop
	fetch c01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	coalesce(ie_status,'X'),
			nr_seq_evento_sistema
		into STRICT	ie_status_w, 
			nr_seq_evento_sistema_w
		from	intpd_fila_transmissao
		where	nr_sequencia = c01_w.nr_sequencia;
		
		open c02;
		loop
		fetch c02 into	
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			update	intpd_fila_transmissao a
			set	ie_status = c02_w.ie_new_status
			where	nr_sequencia = c02_w.nr_sequencia;
			end;
		end loop;
		close c02;
		end;
	end loop;
	close c01;
	end;
end loop;
close c00;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_atualizar_agrup_seq ( nr_seq_agrupador_p bigint default null) FROM PUBLIC;

