-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_informacao_wl ( nr_seq_item_p bigint, ie_opcao_p text, nr_seq_worklist_p wl_worklist.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);
nr_seq_document_w   wl_worklist.nr_seq_document%type;
nr_seq_item_cpoe_w   wl_worklist.nr_seq_item_cpoe%type;
ie_tipo_item_cpoe_w   wl_worklist.ie_tipo_item_cpoe%type;
cd_categoria_w 			wl_item.cd_categoria%type;
/*

A - Acao
C - Categoria
P - Prioridade

*/
BEGIN

IF (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') THEN
	BEGIN

	IF (ie_opcao_p = 'C') THEN

		SELECT 	obter_valor_dominio(8672,CD_CATEGORIA)
		INTO STRICT	ds_retorno_w
		FROM	wl_item
		WHERE	nr_sequencia = nr_seq_item_p;

	ELSIF (ie_opcao_p = 'A') THEN

        select  max(nr_seq_document),
			max(nr_seq_item_cpoe),
			max(ie_tipo_item_cpoe)
        into STRICT    nr_seq_document_w,
			nr_seq_item_cpoe_w,
			ie_tipo_item_cpoe_w
        from    wl_worklist
        where   nr_sequencia = nr_seq_worklist_p;

        if (nr_seq_document_w IS NOT NULL AND nr_seq_document_w::text <> '')then
            select  max(qs.ds_descricao)
            into STRICT    ds_retorno_w
            from    w_modulos_qs qs,
                    episodio_pac_document epd
            where   qs.ds_modulo_id = epd.ds_module_id
            and     epd.nr_sequencia = nr_seq_document_w;
        else
            SELECT  SUBSTR(ds_acao,1,400) 
            INTO STRICT	ds_retorno_w
            FROM	wl_regra_item
            WHERE	nr_sequencia = nr_seq_item_p;
        end if;
		
		if (nr_seq_item_cpoe_w IS NOT NULL AND nr_seq_item_cpoe_w::text <> '' AND ie_tipo_item_cpoe_w IS NOT NULL AND ie_tipo_item_cpoe_w::text <> '') then
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				ds_retorno_w := ds_retorno_w || chr(10);
			end if;
			ds_retorno_w := ds_retorno_w || cpoe_obter_desc_tipo_item(ie_tipo_item_cpoe_w) || ': ' || cpoe_obter_desc_item(nr_seq_item_cpoe_w, ie_tipo_item_cpoe_w);
		end if;		
		 
		select	obter_categoria_worklist( b.NR_SEQ_ITEM ) 
			into STRICT	cd_categoria_w	
		from	wl_regra_item a,
			WL_REGRA_WORKLIST b
		where	a.nr_sequencia = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_regra;
		
		if ( cd_categoria_w = 'D') then
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				ds_retorno_w := ds_retorno_w || chr(10);
			end if;
			ds_retorno_w := ds_retorno_w ||  obter_desc_expressao(707141) || ': ' || wl_obter_horarios_atrasados(nr_seq_item_cpoe_w);
		
		end if;

	ELSIF (ie_opcao_p = 'P') THEN

		SELECT 	obter_valor_dominio(8889,CD_PRIORIDADE)
		INTO STRICT	ds_retorno_w
		FROM	wl_item
		WHERE	nr_sequencia = nr_seq_item_p;

	END IF;
	END;
END IF;

RETURN ds_retorno_w;



END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_informacao_wl ( nr_seq_item_p bigint, ie_opcao_p text, nr_seq_worklist_p wl_worklist.nr_sequencia%type default null) FROM PUBLIC;
