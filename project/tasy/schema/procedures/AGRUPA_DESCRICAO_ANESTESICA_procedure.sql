-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agrupa_descricao_anestesica ( nr_seq_pepo_p bigint, nm_usuario_p text) AS $body$
DECLARE



ds_texto_padrao_p	tecnica_anestesica.ds_texto_padrao_clob%type;
ds_texto_agrupado_p	tecnica_anestesica.ds_texto_padrao_clob%type;
teste_w	bigint;
					
C01 CURSOR FOR
	SELECT	coalesce(a.ds_texto_padrao_clob, a.ds_texto_padrao)
	into STRICT	ds_texto_padrao_p
	from	tecnica_anestesica a,
			cirurgia_tec_anestesica b
	where	a.nr_sequencia = b.nr_seq_tecnica
	and		b.nr_seq_pepo = nr_seq_pepo_p
	and 	coalesce(b.ie_situacao,'A') = 'A'
	and 	coalesce(to_char(a.ds_texto_padrao_clob), coalesce(a.ds_texto_padrao,'XPTO')) <> 'XPTO';	


BEGIN

ds_texto_agrupado_p:= '';

	select	count(*)
	into STRICT	teste_w
	from	tecnica_anestesica a,
			cirurgia_tec_anestesica b
	where	a.nr_sequencia = b.nr_seq_tecnica
	and		b.nr_seq_pepo = nr_seq_pepo_p
	and 	coalesce(b.ie_situacao,'A') = 'A'
	and 	coalesce(to_char(a.ds_texto_padrao_clob), coalesce(a.ds_texto_padrao,'XPTO')) <> 'XPTO';
	
if (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') then

	open C01;
	loop
	fetch C01 into	
		ds_texto_padrao_p;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		ds_texto_agrupado_p := ds_texto_agrupado_p || ds_texto_padrao_p;
		
		end;
	end loop;
	close C01;
	
	if (octet_length(ds_texto_agrupado_p) < 65528) then
		CALL GRAVAR_VARCHAR_PARA_LONG(substr(ds_texto_agrupado_p,32764,1),
								substr(ds_texto_agrupado_p,65528,32765),			
								'anestesia_descricao',		
								'ds_anestesia',			
								' where	nr_seq_pepo = :nr_seq_pepo_p and	dt_liberacao is null ',
								'nr_seq_pepo_p='||nr_seq_pepo_p);	

	else
		update	anestesia_descricao
		set		ds_anestesia = obter_expressao_dic_objeto(1071511)
		where	nr_seq_pepo = nr_seq_pepo_p
		and		coalesce(dt_liberacao::text, '') = '';
	end if;

				
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agrupa_descricao_anestesica ( nr_seq_pepo_p bigint, nm_usuario_p text) FROM PUBLIC;

