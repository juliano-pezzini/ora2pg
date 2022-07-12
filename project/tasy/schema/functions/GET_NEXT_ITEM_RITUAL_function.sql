-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_next_item_ritual (cd_perfil_p bigint, nm_usuario_p text, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE

												
ds_retorno_w		varchar(10);
nr_seq_ritual_w		bigint;
nr_seq_acao_w   	bigint;
nr_seq_item_w   	bigint;


BEGIN
if (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then
	
	select	 max(a.nr_seq_ritual), max(b.nr_seq_acao)
	into STRICT     nr_seq_ritual_w, nr_seq_acao_w
	from	 pep_ritual_item a,
			 pep_ritual_item_acao b
	where	 a.nr_sequencia = b.nr_seq_ritual_item
	and	     a.nr_seq_ritual = obter_ritual_pep(cd_perfil_p,nm_usuario_p)
	and      a.nr_seq_item = nr_seq_item_p
	and      b.nr_seq_acao in (32, 33, 39)
	order by a.dt_atualizacao;
	
	if (nr_seq_acao_w = 32) then
		ds_retorno_w := 'MODAL';
	
	elsif (nr_seq_acao_w = 33) then
		select	distinct first_value(a.nr_seq_item) over (order by a.nr_seq_apresent)
		into STRICT	nr_seq_item_w
		from	pep_ritual_item_sequencia a
		where	(a.nr_seq_apresent IS NOT NULL AND a.nr_seq_apresent::text <> '')
		and		a.nr_seq_ritual = nr_seq_ritual_w
		and		(((SELECT	count(*)
				from		pep_ritual_item_sequencia b
				where		b.nr_seq_item = nr_seq_item_p
				and			b.nr_seq_ritual = nr_seq_ritual_w) > 0)
				and			((select	max(c.nr_seq_apresent)
							from		pep_ritual_item_sequencia c
							where		c.nr_seq_item = nr_seq_item_p
							and			(c.nr_seq_apresent IS NOT NULL AND c.nr_seq_apresent::text <> '')
							and			c.nr_seq_ritual = nr_seq_ritual_w) < a.nr_seq_apresent));
									 									 		
		if (nr_seq_item_w IS NOT NULL AND nr_seq_item_w::text <> '') then
			ds_retorno_w := to_char(nr_seq_item_w);

		end if;

  end if;

  if (nr_seq_acao_w = 39) then
    ds_retorno_w := ds_retorno_w || '#SEND_MAIL';
	end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_next_item_ritual (cd_perfil_p bigint, nm_usuario_p text, nr_seq_item_p bigint) FROM PUBLIC;
